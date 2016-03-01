require 'fileutils'
require 'tempfile'

class TempTheory
  TEMPFILE_NAME = ['blend', '.dol']
  TEMPFILE_CONTENT = <<DOL
logic OWL

ontology InputSpace1 =
  <URL1>
  REJECTS1
end

ontology InputSpace2 =
  <URL2>
  REJECTS2
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
    . false %implied %(inconsistency)%
end
DOL

  attr_accessor :url1, :url2, :rejects1, :rejects2

  def initialize(url1, url2)
    self.url1 = url1
    self.url2 = url2
    self.rejects1 = []
    self.rejects2 = []
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
      rescue => e
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

  def reject1(name)
    rejects1 << name
  end

  def reject2(name)
    rejects2 << name
  end

  protected

  def file_content
    TEMPFILE_CONTENT.
      sub('URL1', url1).
      sub('URL2', url2).
      sub('REJECTS1', rejects_string1).
      sub('REJECTS2', rejects_string1)
  end

  def rejects_string1
    if rejects1.any?
      "reject #{rejects1.join(', ')}"
    else
      ""
    end
  end

  def rejects_string2
    if rejects2.any?
      "reject #{rejects2.join(', ')}"
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
end
