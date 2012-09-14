require 'sinatra/base'
require 'em-synchrony'
require 'async-rack'

module Sinatra
  class Symphony < Base

    # defaults
    disable :raise_errors, :show_exceptions

    def invoke
      EM.synchrony do
        super
        env['async.callback'].call response.finish
      end

      throw :async
    end
  end # Symphony
end # Sinatra
