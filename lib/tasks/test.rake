require 'bundler/setup'
require 'rake/testtask'
require 'bayes'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  #test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test
