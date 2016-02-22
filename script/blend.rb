class Blend
  BLEND_URL = '148.251.85.37:8300/cmd/blend'

  attr_accessor :input_space1, :input_space2

  def initialize(input_space1, input_space2)
    self.input_space1 = input_space1
    self.input_space2 = input_space2
  end

  def run
    call_remote_server
  end

  protected

  def call_remote_server
    JSON.parse(RestClient::Request.post(url: BLEND_URL, params))
  end

  def params
    {
      action: 'hets',
      input1: {url: ARGV[0]}.to_json,
      input2: {url: ARGV[1]}.to_json
    }
  end
end

if ARGV[0] && ARGV[1]
  puts Blend.new(ARGV[0], ARGV[1]).run.inspect
else
  $stderr.puts 'Specify two URLs to ontologies.'
end
