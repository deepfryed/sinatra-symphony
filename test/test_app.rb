require 'helper'

describe 'sinatra-symphony app' do
  def app
    Sinatra::Symphony::Test.new(@myapp)
  end

  it 'should run' do
    @myapp = Class.new(Sinatra::Symphony) do
      get '/hello' do
        'world'
      end
    end

    get '/hello'
    assert_equal 200,     last_response.status
    assert_equal 'world', last_response.body
  end

  it 'should work with rack-test' do
    @myapp = Class.new(Sinatra::Symphony) do
      get '/' do
        http = EM::HttpRequest.new('http://www.google.com/foobar').get
        status http.response_header.status
        '404'
      end
    end

    get '/'
    assert_equal 404,   last_response.status
    assert_equal '404', last_response.body
  end
end
