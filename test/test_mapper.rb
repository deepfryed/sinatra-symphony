require 'helper'

describe 'Rack::Mapper' do
  def app
    Sinatra::Symphony::Test.new(Rack::Mapper.new('/hello' => @myapp))
  end

  it 'should run' do
    mylogs = StringIO.new
    @myapp = Class.new(Sinatra::Symphony) do
      use Rack::Mapper::AsyncLogger, mylogs
      get '/world' do
        [@path, '/world']
      end
    end

    get '/hello/world'
    assert_equal 200,            last_response.status
    assert_equal '/hello/world', last_response.body

    mylogs.rewind
    assert_match %r{GET /hello/world}, mylogs.read
  end
end
