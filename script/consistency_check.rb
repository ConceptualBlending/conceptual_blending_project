require 'tempfile'
require 'rest-client'
require_relative 'hets_basics.rb'
require_relative 'user_interaction.rb'

class ConsistencyCheck
  include HetsBasics

  MAX_TRIES = 3
  BASE_TIMEOUT = 10

  CONSISTENCY_CHECK_REQUEST_DATA = {format: 'json',
                                    includeProof: 'false',
                                    includeDetails: 'false'}

  attr_accessor :theory_url, :consistency_checkers, :consistency_checker,
                :result

  def initialize(theory_url)
    self.theory_url = theory_url
  end

  def run
    retrieve_consistency_checkers
    select_consistency_checker
    try_until_limit_reached_or_solved(limit: MAX_TRIES) do |timeout|
      check_consistency(timeout)
    end

    if theory_consistent?
      true
    elsif theory_inconsistent?
      false
    else
      :consistency_could_not_be_determined
    end
  end

  protected

  def retrieve_consistency_checkers
    self.consistency_checkers =
      call_hets_api(:get,
                    hets_action_url_consistency_checkers(theory_url))['consistency_checkers']
  end

  def select_consistency_checker
    index = UserInteraction.
      new("Please select a consistency checker.",
          consistency_checkers.map { |cc| cc['name'] }).run
    self.consistency_checker = consistency_checkers[index]
  end

  def check_consistency(timeout)
    self.result = call_hets_api(:post,
                                hets_action_url_consistency_check(theory_url),
                                consistency_check_request_data(timeout))
  end

  def consistency_check_request_data(timeout)
    CONSISTENCY_CHECK_REQUEST_DATA.
      merge('consistency-checker' => consistency_checker['identifier'],
            timeout: timeout.to_s).to_json
  end

  def hets_action_url_consistency_checkers(filepath)
    url =
      if filepath.start_with?('/')
        "file://#{filepath}"
      else
        filepath
      end
    "#{HetsBasics::HETS_URL}/consistency-checkers/#{escape(url)}/auto?format=json"
  end

  def hets_action_url_consistency_check(filepath)
    url =
      if filepath.start_with?('/')
        "file://#{filepath}"
      else
        filepath
      end
    "#{HetsBasics::HETS_URL}/consistency-check/#{escape(url)}/auto"
  end

  def solved_check
    ->() { !theory_open? }
  end

  def timeout_increment
    ->(try_count) { BASE_TIMEOUT * try_count }
  end

  def theory_open?
    result.nil? || !(theory_consistent? || theory_inconsistent?)
  end

  def theory_consistent?
    proving_data['result'] == 'Consistent'
  end

  def theory_inconsistent?
    proving_data['result'] == 'Inconsistent'
  end

  def proving_data
    result.first['goals'].first
  end
end


if ARGV[0]
  puts ConsistencyCheck.new(ARGV[0]).run.inspect
else
  $stderr.puts 'Specify a URL to an ontology.'
end
