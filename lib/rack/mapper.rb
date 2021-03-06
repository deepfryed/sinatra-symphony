require 'rack'
require 'async_rack'

module Rack
  class Mapper
    def initialize map
      @map = remap(map)
    end

    def remap map
      map.map     {|path, app| [path, app.respond_to?(:new) ? app_instance(app, path) : app]}
         .sort_by {|path, app| path.size}.reverse
         .map     {|path, app| [Regexp.new("^#{path.chomp('/')}(?:/(.*)|$)"), path, app]}
    end

    def call env
      rest, path, app = find_mapping(env['PATH_INFO'])
      app ? dispatch(app, env, rest, path) : not_found(env)
    end

    def app_instance app, path
      app.new do |instance|
        instance.instance_variable_set(:@rack_mapper_path, path)
      end
    end

    def dispatch app, env, rest, path
      app.call(
        env.merge(
          'PATH_INFO'    => rest,
          'SCRIPT_NAME'  => ::File.join(env['SCRIPT_NAME'], path),
          'REQUEST_PATH' => ::File.join(env['SCRIPT_NAME'], path, rest),
        )
      )
    end

    def not_found env
      [404, {"Content-Type" => "text/plain", "X-Cascade" => "pass"}, ["no application mounted at #{env['REQUEST_PATH']}"]]
    end

    def find_mapping path
      @map.each do |re, location, app|
        if re.match(path)
          return ["/#{$1}", location, app]
        end
      end
      return nil
    end

    class Logger < Rack::CommonLogger
      def log env, status, header, began_at
        env_path_info    = env['PATH_INFO']
        env['PATH_INFO'] = env['REQUEST_PATH'] || ::File.join(env['SCRIPT_NAME'], env['PATH_INFO'])
        super
      ensure
        env['PATH_INFO'] = env_path_info
      end
    end # Logger

    class AsyncLogger < AsyncRack::CommonLogger
      def log env, status, header, began_at
        env_path_info    = env['PATH_INFO']
        env['PATH_INFO'] = env['REQUEST_PATH'] || ::File.join(env['SCRIPT_NAME'], env['PATH_INFO'])
        super
      ensure
        env['PATH_INFO'] = env_path_info
      end
    end # AsyncLogger
  end # Mapper
end # Rack
