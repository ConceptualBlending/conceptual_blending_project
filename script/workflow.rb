require_relative 'inconsistency_check.rb'

class Workflow
  attr_accessor :input_space1, :input_space2

  def initialize(input_space1, input_space2)
    self.input_space1 = input_space1
    self.input_space2 = input_space2
    @mutex = Mutex.new
  end

  def run
    translate_input_spaces_to_casl
    format_casl_for_hdtp
    basic_loop
  end

  protected

  def translate_input_spaces_to_casl
    # TODO
  end

  def format_casl_for_hdtp
    # TODO
  end

  def basic_loop
    while !consistency_found?
      compute_generic_space_and_blend
      run_checks

      if @consistent.nil?
        handle_consistency_check_not_finished_error
      elsif @consistent
        handle_consistency
      else
        handle_inconsistency
      end
    end
  end

  def consistency_found?
    @consistent == true
  end

  def compute_generic_space_and_blend
    # TODO
  end

  def run_checks
    @consistent = nil
    @inconsistent = nil
    @used_axioms = nil

    @consistency_thread = Thread.new { check_consistency }
    @inconsistency_thread = Thread.new { check_inconsistency }

    @consistency_thread.join
    @inconsistency_thread.join
  end

  def check_consistency
    # TODO actually check consistency and set local variable `consistent`
    set_consistent_and_terminate_other_thread if consistent
  end

  def check_inconsistency
    # TODO specify SOME_URL
    result = InconsistencyCheck.new(SOME_URL).run
    inconsistent = result != :theory_is_consistent
    set_inconsistent_and_terminate_other_thread if inconsistent
    @used_axioms = result
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
    @mutex.synchronize { @consistent = true }
    puts __method__
  end

  def set_inconsistent
    @mutex.synchronize { @consistent = false }
    puts __method__
  end

  def handle_consistency_check_not_finished_error
    raise "[In]Consistency check did not properly finish."
  end

  def handle_consistency
    puts __method__
    # do nothing
  end

  def handle_inconsistency
    axiom = let_user_select_axiom_to_remove
    input_space, input_axiom = identify_axiom_in_input_spaces(axiom)
    remove_axiom_from_input_space(input_space, input_axiom)
    puts __method__
  end

  def let_user_select_axiom_to_remove
    # TODO
  end

  def identify_axiom_in_input_spaces(axiom)
    # TODO return an array [input_space, corresponding_axiom_in_input_space]
  end

  def remove_axiom_from_input_space(input_space, axiom)
    # TODO
  end
end
