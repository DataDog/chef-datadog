#!/usr/bin/env rake

require 'foodcritic'
require 'rspec/core/rake_task'
require 'tailor/rake_task'

task :default => [
  :tailor,
  :foodcritic,
  :spec
]

Tailor::RakeTask.new do |task|
  task.file_set('attributes/**/*.rb', "attributes") do |style|
    style.max_line_length 160, :level => :warn
  end
  task.file_set('definitions/**/*.rb', "definitions")
  task.file_set('libraries/**/*.rb', "libraries")
  task.file_set('metadata.rb', "metadata") do |style|
    style.max_line_length 160, :level => :warn
  end
  task.file_set('providers/**/*.rb', "providers")
  task.file_set('recipes/**/*.rb', "recipes") do |style|
    style.max_line_length 160, :level => :warn
  end
  task.file_set('resources/**/*.rb', "resources")
  task.file_set('spec/**/*.rb', "tests") do |style|
    style.max_line_length 160, :level => :warn
  end
end

FoodCritic::Rake::LintTask.new do |t|
  t.options = { :fail_tags => ['correctness'] }
  t.options = { :chef_version => '0.10.8' }
end

# Rspec and ChefSpec
desc "Run ChefSpec examples"
RSpec::Core::RakeTask.new(:spec)

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end
