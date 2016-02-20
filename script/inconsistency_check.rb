require 'tempfile'
require 'rest-client'
require_relative 'hets_basics.rb'

class InconsistencyCheck
  include HetsBasics

  FILE_CONTENT = <<HET
spec Inconsistency =
  <URL>
  then
    . false %implied %(inconsistency)%
  end
HET
  MAX_TRIES = 3
  BASE_TIMEOUT = 10
  REQUEST_DATA = {format: 'json',
                  theorems: ['inconsistency'],
                  node: 'Inconsistency',
                  includeProof: 'false',
                  includeDetails: 'false'}

  attr_accessor :theory_url, :result

  def initialize(theory_url)
    self.theory_url = theory_url
  end

  def run
    try_until_limit_reached_or_solved(limit: MAX_TRIES) do |timeout|
      check_inconsistency(timeout)
    end

    if theory_inconsistent?
      used_axioms
    elsif theory_open?
      :consistency_could_not_be_determined
    else
      :theory_is_consistent
    end
  end

  protected

  def solved_check
    ->() { !theory_open? }
  end

  def timeout_increment
    ->(try_count) { BASE_TIMEOUT * try_count }
  end

  def check_inconsistency(timeout)
    with_tempfile do |filepath|
      self.result = call_hets_api(:post,
                                  hets_action_url(filepath),
                                  request_data(timeout))
    end
  end

  def with_tempfile
    Tempfile.create(['inconsistency_check', '.het']) do |f|
      f.write file_content
      f.close
      yield(f.path)
    end
  end

  def request_data(timeout)
    REQUEST_DATA.merge(timeout: timeout.to_s).to_json
  end

  def file_content
    FILE_CONTENT.sub('URL', theory_url)
  end

  def hets_action_url(filepath)
    url = "file://#{filepath}"
    "#{HetsBasics::HETS_URL}/prove/#{escape(url)}/auto"
  end

  def theory_inconsistent?
    proving_data['result'].start_with?('Proved')
  end

  def theory_open?
    result.nil? || proving_data['result'].start_with?('Open')
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
