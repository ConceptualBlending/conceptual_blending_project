require 'fileutils'
require 'tempfile'
require_relative 'hets_extraction.rb'

class TempTheory
  INDENTATION_LEVEL = 2
  INCONSISTENCY_THEOREM_NAME = 'inconsistency'
  TEMPFILE_NAME = ['blend', '.dol']
  TEMPFILE_CONTENT = <<DOL
logic OWL

ontology InputSpace1 =
  ONTOLOGY1REJECTS1
end

ontology InputSpace2 =
  ONTOLOGY2REJECTS2
end

ontology Base =
  InputSpace1 intersect InputSpace2
end

ontology Blend =
  combine InputSpace1, InputSpace2, Base
end

logic CASL

ontology Inconsistency =
  Blend
  then
    . false %implied %(#{INCONSISTENCY_THEOREM_NAME})%
end
DOL

  attr_accessor :url1, :url2, :rejects1, :rejects2, :ontology1, :ontology2

  def initialize(url1, url2)
    self.url1 = url1
    self.url2 = url2
    self.rejects1 = []
    self.rejects2 = []
    self.ontology1 = nil
    self.ontology2 = nil
  end

  def run
    error = nil
    filepath = nil
    filecontents = nil
    Tempfile.create(TEMPFILE_NAME) do |tempfile|
      tempfile.write(file_content)
      tempfile.close
      begin
        yield(tempfile.path)
      rescue Exception => e
        filepath = tempfile.path
        filecontents = File.open(tempfile.path, 'r').read
        error = e
      end
    end
    # restoring the tempfile needs to be done after Tempfile's error handling / block
    if error
      restore(filepath, filecontents)
      raise error
    end
  end

  def drop1(axioms, name)
    if ENV['AXIOM_DROP_METHOD'] == 'remove'
      remove1(axioms, name)
    else
      reject1(axioms, name)
    end
  end

  def drop2(axioms, name)
    if ENV['AXIOM_DROP_METHOD'] == 'remove'
      remove2(axioms, name)
    else
      reject2(name)
    end
  end

  def remove1(axioms, name)
    axiom_text = axioms['InputSpace1'].select { |ax| ax[:name] == name }.first[:text]
    ontology1.sub!(indent(axiom_text, INDENTATION_LEVEL), '')
  end

  def remove2(axioms, name)
    axiom_text = axioms['InputSpace2'].select { |ax| ax[:name] == name }.first[:text]
    ontology2.sub!(indent(axiom_text, INDENTATION_LEVEL), '')
  end

  def reject1(name)
    rejects1 << name
  end

  def reject2(name)
    rejects2 << name
  end

  protected

  def file_content
    content = TEMPFILE_CONTENT.
      sub('REJECTS1', rejects_string1).
      sub('REJECTS2', rejects_string2)

    self.ontology1 ||=
      if match = url1.match(%r|(?<url>.*)//(?<node>[^/]+)$|)
        indent(HetsExtraction.new(match[:url],
                                  [match[:node]]).run[match[:node]], INDENTATION_LEVEL)
      else
        indent(HetsExtraction.new(url1, []).run, 1)
      end

    self.ontology2 ||=
      if match = url2.match(%r|(?<url>.*)//(?<node>[^/]+)$|)
        indent(HetsExtraction.new(match[:url],
                                  [match[:node]]).run[match[:node]], INDENTATION_LEVEL)
      else
        indent(HetsExtraction.new(url2, []).run, 1)
      end

    content.sub!('ONTOLOGY1', ontology1)
    content.sub!('ONTOLOGY2', ontology2)

    content
  end

  def rejects_string1
    if rejects1.any?
      "\n  reject #{rejects1.join(', ')}"
    else
      ""
    end
  end

  def rejects_string2
    if rejects2.any?
      "\n  reject #{rejects2.join(', ')}"
    else
      ""
    end
  end

  def restore(filepath, filecontents)
    FileUtils.mkdir_p(File.dirname(filepath))
    File.open(filepath, 'w') do |f|
      f.write(filecontents)
    end
    $stderr.puts "The tempfile has been kept at #{filepath}"
  end

  def indent(string, level)
    string.lines.map { |l| l.strip.empty? ? "\n" : "#{'  ' * level}#{l}" }.join
  end
end
