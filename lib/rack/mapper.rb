require 'rack'
require 'async_rack'

module Rack
  class Mapper
    def initialize map
      @map = remap(map)
    end

    def remap map
      Hash[map.map {|path, app| [path, app.respond_to?(:new) ? app_instance(app, path) : app]}]
    end

    def call env
      rest, path, app = find_mapping(env['PATH_INFO'])
      app ? dispatch(app, env, rest, path) : not_found(env)
    end

    def app_instance app, path
      app.new do |instance|
        instance.instance_variable_set(:@path, path)
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
      parts = path.squeeze('/').split('/').each_with_object([]) {|e, a| a << ::File.join(a.last.to_s, e)}.reverse
      parts.each do |mount|
        if app = @map[mount]
          return path.sub(%r{^#{mount}}, ''), mount, app
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
