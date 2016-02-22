require 'tempfile'

class Translate
  HETS_EXECUTABLE = 'hets'

  attr_accessor :theory_url, :comorphisms
  attr_accessor :stdin, :stdout, :stderr

  def initialize(theory_url, *comorphisms)
    self.theory_url = theory_url
    self.comorphisms = comorphisms
  end

  def run
    result = nil
    run_on_local_file do |local_theory_url|
      result = translate_call(local_theory_url)
    end
    result
  end

  protected

  def run_on_local_file
    if remote?
      on_downloaded_file { |filepath| yield(filepath) }
    else
      yield(theory_url)
    end
  end

  def translate_call(local_theory_url)
    hets_output =
      %x[#{HETS_EXECUTABLE} -v -o th -t #{comorphisms.join(':')} #{local_theory_url}]
    File.read(hets_output.match(/Writing file: (?<filepath>.*)$/)[:filepath])
  end

  def remote?
    !!theory_url.match(%r(\A(\w+)://))
  end

  def on_downloaded_file
    name_components = File.basename(theory_url).split('.', 2)
    Tempfile.create([name_components[0], ".#{name_components[1]}"]) do |tempfile|
      tempfile.write(%x(curl -L #{theory_url}))
      tempfile.flush
      yield(tempfile.path)
    end
  end
end

if ARGV[0] && ARGV[1]
  puts Translate.new(ARGV[0], ARGV[1..-1]).run
else
  $stderr.puts 'Specify: ontology url and list of comorphisms.'
end
