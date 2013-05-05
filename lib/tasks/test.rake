require 'bundler/setup'
require 'rake/testtask'
require 'fileutils'

Rake::TestTask.new(:test) do |test|
  FileUtils.rm_rf Rails.root.join('tmp').join('test')
  FileUtils.mkdir Rails.root.join('tmp').join('test')
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test