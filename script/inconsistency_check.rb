require 'tempfile'
require 'rest-client'

class InconsistencyCheck
  HETS_URL = "http://localhost:8000"
  FILE_CONTENT = <<HET
spec Inconsistency =
  <URL>
  then
    . false %implied %(inconsistency)%
  end
HET
  REQUEST_DATA = {format: 'json',
                  theorems: ['inconsistency'],
                  node: 'Inconsistency',
                  includeProof: 'false',
                  includeDetails: 'false'}.to_json

  attr_accessor :theory_url, :result

  def initialize(theory_url)
    self.theory_url = theory_url
  end

  def run
    call_hets

    if theory_inconsistent?
      used_axioms
    else
      :theory_is_consistent
    end
  end

  protected

  def call_hets
    with_tempfile do |filepath|
      begin
        response = RestClient.post(hets_prove_url(filepath), REQUEST_DATA,
                                   content_type: :json,
                                   accept: :json)
        self.result = JSON.parse(response)
      rescue
        if response
          $stderr.puts "Received response:"
          $stderr.puts response
        end
        raise
      end
    end

  end

  def with_tempfile
    Tempfile.create(['inconsistency_check', '.het']) do |f|
      f.write file_content
      f.close
      yield(f.path)
    end
  end

  def file_content
    FILE_CONTENT.sub('URL', theory_url)
  end

  def hets_prove_url(filepath)
    url = "file://#{filepath}"
    "#{HETS_URL}/prove/#{escape(url)}/auto"
  end

  def escape(url)
    URI.encode_www_form_component(url)
  end

  def theory_inconsistent?
    proving_data['result'] == 'Proved'
  end

  def used_axioms
    proving_data['used_axioms']
  end

  def proving_data
    result.first['goals'].first
  end
end


if ARGV[0]
  puts InconsistencyCheck.new(ARGV[0]).run.inspect
else
  $stderr.puts 'Specify a URL to an ontology.'
end
