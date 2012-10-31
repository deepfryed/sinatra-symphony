# Sinatra Symphony

A simple glue for running Sinatra apps along with em-synchrony.

## Example

```ruby
require 'sinatra-symphony'
require 'em-synchrony/em-http'

class MyApp < Sinatra::Symphony
  get '/' do
    http = EM::HttpRequest.new('http://www.google.com').get(redirects: 0)
    "google returned http status of #{http.response_header.status}"
  end
end
```

```
$ ab -n1 -c1 http://127.0.0.1:3000/

<snip>
Total transferred:      137 bytes
HTML transferred:       34 bytes
Requests per second:    3.09 [#/sec] (mean)
Time per request:       323.539 [ms] (mean)
Time per request:       323.539 [ms] (mean, across all concurrent requests)
Transfer rate:          0.41 [Kbytes/sec] received

$ ab -n2 -c2 http://127.0.0.1:3000/

<snip>
Total transferred:      274 bytes
HTML transferred:       68 bytes
Requests per second:    5.36 [#/sec] (mean)
Time per request:       373.161 [ms] (mean)
Time per request:       186.581 [ms] (mean, across all concurrent requests)
Transfer rate:          0.72 [Kbytes/sec] received
```

## Testing

Uses good old `rack-test` and a wrapper.

```ruby
  require 'minitest/autorun'
  require 'sinatra/symphony/test'

  class MiniTest::Spec
    include Rack::Test::Methods
    
    def app
      Sinatra::Symphony::Test.new(@myapp) 
    end
  end

  describe 'myapp' do
    it 'should work' do
      @myapp = Class.new(Sinatra::Symphony) do
        get '/' do
          'hello world'
        end
      end

      get '/'
      assert_equal 'hello world', last_response.body
    end
  end
```

# See Also
[https://github.com/kyledrake/sinatra-synchrony](https://github.com/kyledrake/sinatra-synchrony)

# License
[Creative Commons Attribution - CC BY](http://creativecommons.org/licenses/by/3.0)
