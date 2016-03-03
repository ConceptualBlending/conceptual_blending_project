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
  MAX_TRIES = 1
  BASE_TIMEOUT = 30
  REQUEST_DATA = {format: 'json',
                  theorems: ['inconsistency'],
                  node: 'Inconsistency',
                  includeProof: 'false',
                  includeDetails: 'false'}

  attr_accessor :theory_url, :provers, :prover, :result, :mutex, :prover

  def initialize(theory_url, mutex = nil, prover = nil)
    self.theory_url = theory_url
    self.mutex = mutex
    self.prover = prover
  end

  def run
      retrieve_provers unless prover
      select_prover unless prover
      try_until_limit_reached_or_solved(limit: MAX_TRIES) do |timeout|
        check_inconsistency(timeout)
    end

    if theory_inconsistent?
      [used_axioms, prover]
    elsif theory_open?
      [:consistency_could_not_be_determined, prover]
    else
      [:theory_is_consistent, prover]
    end
  end

  protected

  def solved_check
    ->() { !theory_open? }
  end

  def timeout_increment
    ->(try_count) { BASE_TIMEOUT * try_count }
  end

  def retrieve_provers
    self.provers =
      call_hets_api(:get, hets_action_url_provers(theory_url))['provers']
  end

  def select_prover
    index = UserInteraction.
      new("Please select a prover for the inconsistency check.",
          provers.map { |cc| cc['name'] }, mutex).run
    self.prover = provers[index]['identifier']
  end

  def check_inconsistency(timeout)
    self.result = call_hets_api(:post,
                                hets_action_url_prove(theory_url),
                                request_data(timeout))
  end

  def request_data(timeout)
    REQUEST_DATA.merge(timeout: timeout.to_s,
                      prover: prover).to_json
  end

  def hets_action_url_provers(url)
    "#{HetsBasics::HETS_URL}/provers/#{escape(url)}/auto?format=json"
  end

  def hets_action_url_prove(url)
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


# if ARGV[0]
#   puts InconsistencyCheck.new(ARGV[0]).run.inspect
# else
#   $stderr.puts 'Specify a URL to an ontology.'
# end
