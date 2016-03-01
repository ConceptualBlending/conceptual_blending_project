class UserInteraction
  attr_accessor :question, :options, :selection_index, :mutex

  def initialize(question, options, mutex = nil)
    self.question = question
    self.options = options
    self.mutex = mutex
  end

  def run
    if mutex
      mutex.synchronize { execute }
    else
      execute
    end
  end

  protected

  def execute
    print_question_with_options
    self.selection_index = from_print_index($stdin.gets.strip.to_i)

    if (0..options.size - 1).include?(selection_index)
      print_selection
      selection_index
    else
      print_error_message
      run
    end
  end

  def selected_option
    options[selection_index]
  end

  def print_question_with_options
    puts question
    options.each_with_index do |option, index|
      puts "[#{to_print_index(index)}] #{option}"
    end
    puts "Enter a number between 1 and #{options.size}."
  end

  def print_selection
    puts "Selected option #{to_print_index(selection_index)}: #{selected_option}"
    puts
    puts
  end

  def print_error_message
    puts "Selection not recognized: #{to_print_index(selection_index)}. Please try again."
  end

  def to_print_index(index)
    index + 1
  end

  def from_print_index(index)
    index - 1
  end
end
