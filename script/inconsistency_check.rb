require 'tempfile'
require 'rest-client'
require_relative 'hets_basics.rb'
require_relative 'user_interaction.rb'

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

  attr_accessor :theory_url, :provers, :prover, :result

  def initialize(theory_url)
    self.theory_url = theory_url
  end

  def run
    with_tempfile do |filepath|
      retrieve_provers(filepath)
      select_prover
      try_until_limit_reached_or_solved(limit: MAX_TRIES) do |timeout|
        check_inconsistency(filepath, timeout)
      end
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

  def retrieve_provers(filepath)
    self.provers =
      call_hets_api(:get, hets_action_url_provers(filepath))['provers']
  end

  def select_prover
    index = UserInteraction.
      new("Please select a prover for the inconsistency check.",
          provers.map { |cc| cc['name'] }).run
    self.prover = provers[index]['identifier']
  end

  def check_inconsistency(filepath, timeout)
    self.result = call_hets_api(:post,
                                hets_action_url_prove(filepath),
                                request_data(timeout))
  end

  def with_tempfile
    Tempfile.create(['inconsistency_check', '.het']) do |f|
      f.write file_content
      f.close
      yield(f.path)
    end
  end

  def request_data(timeout)
    REQUEST_DATA.merge(timeout: timeout.to_s,
                      prover: prover).to_json
  end

  def file_content
    FILE_CONTENT.sub('URL', theory_url)
  end

  def hets_action_url_provers(filepath)
    url = "file://#{filepath}"
    "#{HetsBasics::HETS_URL}/provers/#{escape(url)}/auto?format=json"
  end

  def hets_action_url_prove(filepath)
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
