require 'fileutils'
require_relative 'consistency_check.rb'
require_relative 'inconsistency_check.rb'
require_relative 'temp_theory.rb'
require_relative 'user_interaction.rb'

class Workflow
  attr_accessor :input_space1, :input_space2, :temp_theory

  def initialize(input_space1, input_space2)
    self.input_space1 = input_space1
    self.input_space2 = input_space2
    self.temp_theory = TempTheory.new(input_space1, input_space2)
    @consistent_attribute_mutex = Mutex.new
    @user_interaction_mutex = Mutex.new
  end

  def run
    basic_loop
  end

  protected

  def basic_loop
    while !consistency_found?
      temp_theory.run do |filepath|
        run_checks("file://#{filepath}")

        if @consistent.nil?
          handle_consistency_check_not_finished_error
        elsif @consistent
          return handle_consistency(filepath)
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
    result = ConsistencyCheck.new(file_url, @user_interaction_mutex).run
    @consistent = result == true
    @inconsistent = result == false
    # TODO what to do on a timeout? (:consistency_could_not_be_determined)
    set_consistent_and_terminate_other_thread if @consistent
  end

  def check_inconsistency(file_url)
    result = InconsistencyCheck.new(file_url, @user_interaction_mutex).run
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
    @consistent_attribute_mutex.synchronize do
      @consistent = true
    end
  end

  def set_inconsistent
    @consistent_attribute_mutex.synchronize do
      @consistent = false
    end
  end

  def handle_consistency_check_not_finished_error
    raise "[In]Consistency check did not properly finish."
  end

  def handle_consistency(filepath)
    now = Time.now.strftime("%Y-%m-%d_%H-%M-%S-%9N")
    target_filepath = File.join(File.dirname(__FILE__), "blend-#{now}.dol")
    FileUtils.cp(filepath, target_filepath)

    puts "Success!"
    puts "The Blend has been stored at #{target_filepath}"

    true
  end

  def handle_inconsistency
    puts "Inconsistency in the Blend detected."
    puts "The following Axioms were used to prove inconsistency."
    axiom = let_user_select_axiom_to_remove
    input_space, input_axiom = identify_axiom_in_input_spaces(axiom)
    remove_axiom_from_input_space(input_space, input_axiom)
  end

  def let_user_select_axiom_to_remove
    index = UserInteraction.
      new("Please select an axiom to drop to restore consistency.",
          @used_axioms).run
    @used_axioms[index]
  end

  def identify_axiom_in_input_spaces(axiom)
    input_spaces = [input_space1, input_space2]
    index = UserInteraction.
      new(%(Please select the input space where the selected axiom "#{axiom}" is originated.),
         input_spaces)
    input_spaces[index]
  end

  def remove_axiom_from_input_space(input_space, axiom)
    if input_space == input_space1
      temp_theory.reject1(axiom)
    else
      temp_theory.reject2(axiom)
    end
  end
end


if ARGV[0] && ARGV[1]
  puts Workflow.new(ARGV[0], ARGV[1]).run.inspect
else
  $stderr.puts 'Specify URLs to two ontologies.'
end
