require 'fileutils'
require_relative 'conceptual_blending/analysis.rb'
require_relative 'conceptual_blending/consistency_check.rb'
require_relative 'conceptual_blending/error.rb'
require_relative 'conceptual_blending/hets_medusa.rb'
require_relative 'conceptual_blending/hets_server.rb'
require_relative 'conceptual_blending/inconsistency_check.rb'
require_relative 'conceptual_blending/temp_theory.rb'
require_relative 'conceptual_blending/user_interaction.rb'

module ConceptualBlending
  class Workflow
    attr_accessor :input_space1, :input_space2, :temp_theory, :axioms,
                  :consistent_attribute_mutex, :user_interaction_mutex,
                  :consistency_checker, :prover,
                  :hets_consistency_check, :hets_inconsistency_check,
                  :now

    def initialize(input_space1, input_space2)
      self.input_space1 = input_space1
      self.input_space2 = input_space2
      self.axioms = []
      self.temp_theory = TempTheory.new(input_space1, input_space2)
      self.consistent_attribute_mutex = Mutex.new
      self.user_interaction_mutex = Mutex.new
      self.consistency_checker = ENV['CONSISTENCY_CHECKER']
      self.prover = ENV['PROVER']
      self.now = Time.now.strftime("%Y-%m-%d_%H-%M-%S-%9N")
      self.hets_consistency_check = HetsServer.new('Hets-Server for consistency checks')
      self.hets_inconsistency_check = HetsServer.new('Hets-Server for inconsistency checks')
    end

    def call
      hets_consistency_check.call do |hets_consistency_check_url|
        hets_inconsistency_check.call do |hets_inconsistency_check_url|
          basic_loop(hets_consistency_check_url, hets_inconsistency_check_url)
        end
      end
    end

    protected

    def basic_loop(hets_consistency_check_url, hets_inconsistency_check_url)
      while !consistency_found?
        temp_theory.call do |temp_filepath|
          self.axioms = Analysis.new(temp_filepath).call
          run_checks("file://#{temp_filepath}", hets_consistency_check_url, hets_inconsistency_check_url)

          if @consistent.nil?
            handle_consistency_check_not_finished_error
          elsif @consistent
            return handle_consistency(temp_filepath)
          else
            handle_inconsistency
          end
        end
      end
    end

    def consistency_found?
      @consistent == true
    end

    def run_checks(file_url, hets_consistency_check_url, hets_inconsistency_check_url)
      @consistent = nil
      @inconsistent = nil
      @used_axioms = nil

      @consistency_thread = Thread.new { check_consistency(file_url, hets_consistency_check_url) }
      @inconsistency_thread = Thread.new { check_inconsistency(file_url, hets_inconsistency_check_url) }

      @consistency_thread.join
      @inconsistency_thread.join
    end

    def check_consistency(file_url, hets_consistency_check_url)
      result, self.consistency_checker =
        ConsistencyCheck.new(hets_consistency_check_url, file_url,
                             user_interaction_mutex, consistency_checker).call
      if result == :consistency_could_not_be_determined
        index = UserInteraction.
          new("A timeout occurred in the consistency check with #{consistency_checker}.\n"\
                "Do you want to retry (you may choose another consistency checker)?",
              %w(Yes No), user_interaction_mutex).call
        if index == 0 # retry
          self.consistency_checker = nil
          check_consistency(file_url)
        else
          @inconsistency_thread.kill
          raise UserError, "Aborted by user."
        end
      else
        @consistent = result == true
        @inconsistent = result == false
        # TODO what to do on a timeout? (:consistency_could_not_be_determined)
        set_consistent_and_terminate_other_thread if @consistent
      end
    end

    def check_inconsistency(file_url, hets_inconsistency_check_url)
      result, self.prover =
        InconsistencyCheck.new(hets_inconsistency_check_url, file_url,
                               user_interaction_mutex, prover).call
      if result == :consistency_could_not_be_determined
        index = UserInteraction.
          new("A timeout occurred in the inconsistency check with #{prover}.\n"\
                "Do you want to retry (you may choose another prover)?",
              %w(Yes No), user_interaction_mutex).call
        if index == 0 # retry
          self.prover = nil
          check_inconsistency(file_url)
        else
          @consistency_thread.kill
          raise UserError, "Aborted by user."
        end
      else
        @consistent = result == :theory_is_consistent
        @inconsistent = result.is_a?(Array)
        # TODO what to do on a timeout? (:consistency_could_not_be_determined)
        set_inconsistent_and_terminate_other_thread if @inconsistent
        @used_axioms = result if @inconsistent
      end
    end

    def set_consistent_and_terminate_other_thread
      set_consistent
      @inconsistency_thread.kill
    end

    def set_inconsistent_and_terminate_other_thread
      set_inconsistent
      @consistency_thread.kill
    end

    def set_consistent
      consistent_attribute_mutex.synchronize do
        @consistent = true
      end
    end

    def set_inconsistent
      consistent_attribute_mutex.synchronize do
        @consistent = false
      end
    end

    def handle_consistency_check_not_finished_error
      raise TimeoutError, "[In]Consistency check did not properly finish."
    end

    def handle_consistency(temp_filepath)
      blend_filepath = write_blend_to_dol_file(temp_filepath)
      png_filepath = write_blend_to_png_file(temp_filepath)
    end

    def write_blend_to_dol_file(temp_filepath)
      target_filepath = File.join(File.dirname(__FILE__), "blend-#{now}.dol")
      FileUtils.cp(temp_filepath, target_filepath)

      puts "Successfully created a consistent blend!"
      puts "The blend has been stored at #{target_filepath}"
      target_filepath
    end

    def write_blend_to_png_file(temp_filepath)
      target_png_path = File.join(File.dirname(__FILE__), "blend-#{now}.png")
      if HetsMedusa.new(temp_filepath, target_png_path).call
        puts "Successfully created the blend picture!"
        puts "The blend picture has been stored at #{target_png_path}"
        target_png_path
      else
        puts "Failed to create the Medusa picture."
        nil
      end
    end

    def handle_inconsistency
      puts "Inconsistency in the Blend detected."
      puts "The following Axioms were used to prove inconsistency."
      axiom = let_user_select_axiom_to_remove
      input_space, input_axiom = identify_axiom_in_input_spaces(axiom)
      remove_axiom_from_input_space(input_space, input_axiom)
    end

    def let_user_select_axiom_to_remove
      print_proc = -> (blend_axiom) { print_blend_axiom(blend_axiom) }
      used_blend_axioms_cached = used_blend_axioms
      index = UserInteraction.
        new("Please select an axiom to drop to restore consistency.",
            used_blend_axioms_cached, user_interaction_mutex, print_proc).call
      used_blend_axioms_cached[index]
    end

    def identify_axiom_in_input_spaces(axiom)
      # determine automatically
      if axiom[:originals].any?
        if axiom[:originals]['InputSpace1'] && axiom[:originals]['InputSpace2']
          return [['InputSpace1', 'InputSpace2'],
                  [axiom[:originals]['InputSpace1'].first, axiom[:originals]['InputSpace2'].first]]
        elsif axiom[:originals]['InputSpace1']
          return ['InputSpace1', axiom[:originals]['InputSpace1'].first]
        elsif axiom[:originals]['InputSpace2']
          return ['InputSpace2', axiom[:originals]['InputSpace2'].first]
        end
      end

      # ask user for help
      input_spaces = [['InputSpace1', input_space1], ['InputSpace2', input_space2]]
      index = UserInteraction.
        new(%(Please select the input space where the selected axiom "#{axiom}" is originated (could not determine it automatically).),
           input_spaces, user_interaction_mutex).call
      input_space = input_spaces[index].first

      index = UserInteraction.
        new(%(Please select the axiom "#{axiom}" from this input space.),
           axioms[input_space], user_interaction_mutex).call
      axiom = axioms[input_space][index]

      [input_space, axiom]
    end

    def remove_axiom_from_input_space(input_space, axiom)
      if input_space == ['InputSpace1', 'InputSpace2']
        temp_theory.drop1(axioms, axiom[0][:name])
        temp_theory.drop2(axioms, axiom[1][:name])
      elsif input_space == 'InputSpace1'
        temp_theory.drop1(axioms, axiom[:name])
      else
        temp_theory.drop2(axioms, axiom[:name])
      end
    end

    def used_blend_axioms
      axioms['Blend'].select do |blend_axiom|
        @used_axioms.include?(blend_axiom[:name])
      end
    end

    def print_blend_axiom(blend_axiom)
      if blend_axiom[:originals]
        origin = ''
        if blend_axiom[:originals]['InputSpace1']
          ax = blend_axiom[:originals]['InputSpace1'].first
          origin += "InputSpace1 (#{input_space1})"
        end
        if blend_axiom[:originals]['InputSpace2']
          ax = blend_axiom[:originals]['InputSpace2'].first
          origin += ' and ' unless origin.empty?
          origin += "InputSpace2 (#{input_space2})"
        end
        "From #{origin}:\n#{ax[:name]} #{ax[:text]}\n"
      else
        "Input space not identified:\n#{blend_axiom[:name]} #{blend_axiom[:text]}"
      end
    end
  end
end


if ARGV.any?
  if ARGV[0] && ARGV[1]
    begin
      puts ConceptualBlending::Workflow.new(ARGV[0], ARGV[1]).call.inspect
    rescue ConceptualBlending::Error => e
      $stderr.puts "Error!\n#{e.class}:\n#{e.message}"
      exit 1
    end
  else
    $stderr.puts 'Specify URLs to two ontologies.'
    exit 2
  end
end
