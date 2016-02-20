module HetsBasics
  HETS_URL = "http://localhost:8000"

  def escape(url)
    URI.encode_www_form_component(url)
  end

  def call_hets_api(http_method, url, data = {})
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
      result = JSON.parse(response)
    rescue
      if response
        $stderr.puts "Received response:"
        $stderr.puts response
      end
      raise
    end
    result
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
