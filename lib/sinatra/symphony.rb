require 'sinatra/base'
require 'em-synchrony'
require 'async-rack'

module Sinatra
  class Symphony < Base

    # defaults
    disable :raise_errors, :show_exceptions

    def invoke
      if self.class.symphony[:exclude].include? @request.path_info
        super
      else
        EM.synchrony do
          super
          env['async.callback'].call response.finish
        end

        throw :async
      end
    end

    def self.synchronous *paths
      paths.each do |path|
        symphony[:exclude] << path
      end
    end

    def self.symphony
      @symphony ||= Hash.new {|h, k| h[k] = []}
    end
  end # Symphony
end # Sinatra
