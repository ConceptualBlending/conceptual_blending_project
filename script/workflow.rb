require 'fileutils'
require_relative 'analysis.rb'
require_relative 'completeness_check.rb'
require_relative 'consistency_check.rb'
require_relative 'inconsistency_check.rb'
require_relative 'temp_theory.rb'
require_relative 'user_interaction.rb'

class Workflow
  attr_accessor :input_space1, :input_space2, :temp_theory, :axioms,
                :consistent_attribute_mutex, :user_interaction_mutex,
                :consistency_checker, :prover,
                :now

  def initialize(input_space1, input_space2)
    self.input_space1 = input_space1
    self.input_space2 = input_space2
    self.axioms = []
    self.temp_theory = TempTheory.new(input_space1, input_space2)
    self.consistent_attribute_mutex = Mutex.new
    self.user_interaction_mutex = Mutex.new
    self.consistency_checker = nil
    self.prover = nil
    self.now = Time.now.strftime("%Y-%m-%d_%H-%M-%S-%9N")
  end

  def run
    basic_loop
  end

  protected

  def basic_loop
    while !consistency_found?
      temp_theory.run do |temp_filepath|
        self.axioms = Analysis.new(temp_filepath).run if !axioms.any?
        run_checks("file://#{temp_filepath}")

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

  def run_checks(file_url)
    @consistent = nil
    @inconsistent = nil
    @used_axioms = nil

    @consistency_thread = Thread.new { check_consistency(file_url) }
    @inconsistency_thread = Thread.new { check_inconsistency(file_url) }

    @consistency_thread.join
    @inconsistency_thread.join
  end

  def check_consistency(file_url)
    result, self.consistency_checker =
      ConsistencyCheck.new(file_url, user_interaction_mutex,
                           consistency_checker).run
    @consistent = result == true
    @inconsistent = result == false
    # TODO what to do on a timeout? (:consistency_could_not_be_determined)
    set_consistent_and_terminate_other_thread if @consistent
  end

  def check_inconsistency(file_url)
    result, self.prover =
      InconsistencyCheck.new(file_url, user_interaction_mutex, prover).run
    puts "Result:", result.inspect, self.prover.inspect
    @consistent = result == :theory_is_consistent
    @inconsistent = result.is_a?(Array)
    # TODO what to do on a timeout? (:consistency_could_not_be_determined)
    set_inconsistent_and_terminate_other_thread if @inconsistent
    @used_axioms = result if @inconsistent
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
    raise "[In]Consistency check did not properly finish."
  end

  def handle_consistency(temp_filepath)
    blend_filepath = write_blend_to_dol_file(temp_filepath)
    png_filepath = write_blend_to_pngl_file(temp_filepath)

    true
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
    HetsMedusa.new(temp_filepath, target_png_path).run

    puts "Successfully created the blend picture!"
    puts "The blend picture has been stored at #{target_png_path}"
    target_png_path
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
    index = UserInteraction.
      new("Please select an axiom to drop to restore consistency.",
          used_blend_axioms, user_interaction_mutex, print_proc).run
    used_blend_axioms[index]
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
         input_spaces, user_interaction_mutex).run
    input_space = input_spaces[index].first

    index = UserInteraction.
      new(%(Please select the axiom "#{axiom}" from this input space.),
         axioms[input_space], user_interaction_mutex).run
    axiom = axioms[input_space][index]

    [input_space, axiom]
  end

  def remove_axiom_from_input_space(input_space, axiom)
    if input_space == ['InputSpace1', 'InputSpace2']
      temp_theory.reject1(axiom[0][:name])
      temp_theory.reject2(axiom[1][:name])
    elsif input_space == 'InputSpace1'
      temp_theory.reject1(axiom[:name])
    else
      temp_theory.reject2(axiom[:name])
    end
  end

  def used_blend_axioms
    @used_blend_axioms ||= axioms['Blend'].select do |blend_axiom|
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
      "From #{origin}:\n#{ax[:text]}\n"
    else
      "Input space not identified:\n#{blend_axiom[:text]}"
    end
  end
end


if ARGV.any?
  if ARGV[0] && ARGV[1]
    puts Workflow.new(ARGV[0], ARGV[1]).run.inspect
  else
    $stderr.puts 'Specify URLs to two ontologies.'
  end
end
