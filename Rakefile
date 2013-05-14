#!/usr/bin/env rake

# http://acrmp.github.com/foodcritic/
require 'foodcritic'
# https://github.com/turboladen/tailor
require 'tailor/rake_task'

task :default => [
  :tailor,
  :foodcritic,
  :berks,
  :knife,
  :chefspec
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

# http://berkshelf.com/
desc "Check out cookbooks from Berkshelf to local path"
task :berks do
  sh %{rm -fr ./cookbooks}
  sh %{bundle exec berks install --except integration --path ./cookbooks}
end

desc "Test Datadog cookbook via knife"
task :knife do
  sh %{bundle exec knife cookbook test datadog -o cookbooks}
end

# https://github.com/acrmp/chefspec
desc "Run ChefSpec Unit Tests"
task :chefspec do
  sh %{bundle exec rspec cookbooks/datadog/spec/}
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end
