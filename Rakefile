# encoding: utf-8

$:.unshift File.dirname(__FILE__) 

require 'date'
require 'pathname'
require 'rake'
require 'rake/testtask'

$rootdir = Pathname.new(__FILE__).dirname
$gemspec = Gem::Specification.new do |s|
  s.name              = 'sinatra-symphony'
  s.version           = '0.2.1'
  s.date              = Date.today    
  s.authors           = ['Bharanee Rathna']
  s.email             = ['deepfryed@gmail.com']
  s.summary           = 'em-synchrony glue for sinatra'
  s.description       = 'em-synchrony glue for sinatra.'
  s.homepage          = 'http://github.com/deepfryed/sinatra-symphony'
  s.files             = Dir['{test,lib}/**/*.rb'] + %w(README.md)
  s.require_paths     = %w(lib)

  s.add_dependency('sinatra')
  s.add_dependency('em-synchrony')
  s.add_dependency('async-rack')
  s.add_development_dependency('rake')
  s.add_development_dependency('thin')
  s.add_development_dependency('rack-test')
  s.add_development_dependency('em-http-request')
end

desc 'Generate gemspec'
task :gemspec do 
  $gemspec.date = Date.today
  File.open("#{$gemspec.name}.gemspec", 'w') {|fh| fh.write($gemspec.to_ruby)}
end

Rake::TestTask.new(:test) do |test|
  test.libs   << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task default: :test

desc 'tag release and build gem'
task :release => [:test, :gemspec] do
  system("git tag -m 'version #{$gemspec.version}' v#{$gemspec.version}") or raise "failed to tag release"
  system("gem build #{$gemspec.name}.gemspec")
end
