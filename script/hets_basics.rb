module HetsBasics
  HETS_URL = "http://localhost:8000"

  def escape(url)
    URI.encode_www_form_component(url)
  end

  def call_hets_api(http_method, url, data = {}, parse_json: true)
    result = nil
    begin
      response =
        if http_method == :get
          RestClient.get(url, content_type: :json, accept: :json)
        else
          RestClient.send(http_method, url, data,
                          content_type: :json,
                          accept: :json)
        end
      result = parse_json ? JSON.parse(response) : response
    rescue
      $stderr.puts "Error!"
      $stderr.puts
      if response
        $stderr.puts "Received response:"
        $stderr.puts response
        $stderr.puts "With the following request (rebuilt with curl):"
      else
        $stderr.puts "No processable response received from Hets."
        $stderr.puts "This may be due to an error in Hets."
        $stderr.puts "You can see Hets' behavior by manually executing this command:"
      end
      $stderr.puts
      $stderr.puts hets_curl_command(http_method, url, data)
      $stderr.puts

      raise
    end
    result
  end

  def hets_curl_command(http_method, url, data = {})
    command = "curl -X #{http_method.to_s.upcase}"
    command << ' -H "Accept: application/json"'
    unless http_method == :get
      command << ' -H "Content-Type: application/json"'
      command << " -d '#{data}'"
    end
    command << " #{url}"
    command
  end

  def try_until_limit_reached_or_solved(limit: 1)
    limit.times do |try_count|
      if solved_check.call
        break
      else
        # the try count starts with 0, we want to count from 1
        yield(timeout_increment.call(try_count + 1))
      end
    end
  end

  # base implementation - supposed to be overwritten
  def solved_check
    ->() { true }
  end

  # base implementation - supposed to be overwritten
  def timeout_increment
    ->(_try_count) { base_timeout }
  end
end
