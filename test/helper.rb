require 'bundler/setup'
require 'minitest/autorun'
require 'em-synchrony/em-http'
require 'sinatra-symphony'
require 'thin'
require 'uri'

class MiniTest::Spec
  def schedule app, port = 4000, &block
    res    = nil
    server = fork do
      capture_io do
        Thin::Server.start('127.0.0.1', port, app)
      end
    end

    wait_for_service_start(port)
    schedule_in_thread { res = block.call URI.parse("http://127.0.0.1:#{port}") }
    return res
    ensure
      Process.kill 'KILL', server rescue nil
  end

  def schedule_in_thread &block
    EM.run do
      EM.synchrony do
        block.call
        EM.stop
      end
    end
  end

  def wait_for_service_start port, timeout = 5
    (timeout / 0.1).to_i.times.each do
      sleep 0.1
      break if TCPSocket.new('127.0.0.1', port) rescue nil
    end
  end
end
