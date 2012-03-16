#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ResponseFor'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc', 'CHANGELOG', 'MIT-LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

task :default => [:spec]

desc "Run the specs"
RSpec::Core::RakeTask.new(:spec => []) do |t|
  t.pattern = "./spec/**/*_spec.rb"
end