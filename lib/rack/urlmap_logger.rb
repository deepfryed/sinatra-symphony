require 'async_rack'

module Rack
  class MapperLogger < AsyncRack::CommonLogger
    def log env, status, header, began_at
      env['PATH_INFO'] = env['REQUEST_PATH']
      super
    end
  end
end
