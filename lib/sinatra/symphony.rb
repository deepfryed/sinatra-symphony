require 'sinatra/base'
require 'em-synchrony'
require 'async-rack'

module Sinatra
  class Symphony < Base

    %w(get put post delete).each do |name|
      define_singleton_method(name) do |path, options = {}, &block|
        route(name.upcase, path, options) {|*args| async_invoke(*args, &block)}
      end
    end

    # defaults
    disable :raise_errors, :show_exceptions

    module Helpers
      def async_exec args, block
        catch(:halt) do
          begin
            instance_exec(*args, &block)
          rescue ::Exception => boom
            handle_exception!(boom)
          ensure
            filter! :after unless env['sinatra.static_file']
          end
        end
      end

      def async_invoke *args, &block
        EM.synchrony do
          res = async_exec(args, block)
          res = [res] unless res.kind_of?(Array)

          if Array === res && Fixnum === res.first
            status(res.shift)
            body(res.pop)
            headers(*res)
          else
            body(res)
          end

          env['async.callback'].call response.finish
        end

        throw :async
      end
    end

    include Helpers
  end
end
