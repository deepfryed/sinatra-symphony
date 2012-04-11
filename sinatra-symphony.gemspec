# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sinatra-symphony"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bharanee Rathna"]
  s.date = "2012-04-11"
  s.description = "em-synchrony glue for sinatra"
  s.email = ["deepfryed@gmail.com"]
  s.files = ["test/helper.rb", "test/test_app.rb", "lib/sinatra/symphony.rb", "lib/sinatra-symphony.rb", "README.md"]
  s.homepage = "http://github.com/deepfryed/sinatra-symphony"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.21"
  s.summary = "em-synchrony glue for sinatra"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 0"])
      s.add_runtime_dependency(%q<em-synchrony>, [">= 0"])
      s.add_runtime_dependency(%q<async-rack>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<thin>, [">= 0"])
      s.add_development_dependency(%q<em-http-request>, [">= 0"])
    else
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<em-synchrony>, [">= 0"])
      s.add_dependency(%q<async-rack>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<thin>, [">= 0"])
      s.add_dependency(%q<em-http-request>, [">= 0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<em-synchrony>, [">= 0"])
    s.add_dependency(%q<async-rack>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<thin>, [">= 0"])
    s.add_dependency(%q<em-http-request>, [">= 0"])
  end
end