require 'rack/test'
require 'sinatra-symphony'

module Sinatra
  class Symphony::Test
    def initialize app
      @app = app
    end

    def call env
      EM.run do
        env['async.callback'] = proc {|response| @response = response; EM.stop}
        catch(:async) {@app.call(env)}
      end
      @response
    end
  end # Symphony::Test
end # Sinatra
