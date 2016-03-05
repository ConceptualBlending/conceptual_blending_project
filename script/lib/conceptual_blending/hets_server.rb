require 'socket'
require 'timeout'

module ConceptualBlending
  class HetsServer
    HETS_BINARY = ENV['HETS_BINARY'] || 'hets'
    EXPECTED_STARTUP_TIME = 1 # seconds

    attr_accessor :name

    def initialize(name)
      self.name = name
    end

    def call
      port = choose_port
      puts "Starting #{name} on port #{port}."

      pid = fork { exec("#{HETS_BINARY} --server --listen=#{port}") }
      sleep EXPECTED_STARTUP_TIME
      yield("http://localhost:#{port}")
    ensure
      if pid
        puts "Stopping #{name}"
        Process.kill('INT', pid)
        Process.wait
      end
    end

    protected

    def choose_port
      port = rand(200)+8000
      if port_taken?('127.0.0.1', port)
        choose_port
      else
        port
      end
    end

    def port_taken?(ip, port, seconds = 1)
      Timeout::timeout(seconds) do
        begin
          TCPSocket.new(ip, port).close
          true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          false
        end
      end
    rescue Timeout::Error
      false
    end
  end
end
