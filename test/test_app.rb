require 'helper'

describe 'sinatra-symphony app' do
  it 'should run' do
    myapp = Class.new(Sinatra::Symphony) do
      get '/hello' do
        'world'
      end
    end

    http = schedule(myapp) {|base_uri| EM::HttpRequest.new((base_uri + '/hello').to_s).get}
    assert http
    assert_equal 200,     http.response_header.status
    assert_equal 'world', http.response
  end
end
