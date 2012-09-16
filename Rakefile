#!/usr/bin/env rake

# http://acrmp.github.com/foodcritic/
require 'foodcritic'
# https://github.com/turboladen/tailor
require 'tailor/rake_task'

task :default => [:tailor, :foodcritic, :knife, :chefspec]

Tailor::RakeTask.new do |task|
  task.file_set('attributes/**/*.rb', "attributes") do |style|
    style.max_line_length 160, level: :warn
  end
  task.file_set('definitions/**/*.rb', "definitions")
  task.file_set('libraries/**/*.rb', "libraries")
  task.file_set('metadata.rb', "metadata")
  task.file_set('providers/**/*.rb', "providers")
  task.file_set('recipes/**/*.rb', "recipes") do |style|
    style.max_line_length 160, level: :warn
  end
  task.file_set('resources/**/*.rb', "resources")
  # task.file_set('templates/**/*.erb', "templates")
end

FoodCritic::Rake::LintTask.new do |t|
  t.options = { :fail_tags => ['correctness'] }
  t.options = { :chef_version => '0.10.8' }
end

# http://berkshelf.com/
desc "Install Berkshelf shims"
task :berks do
  sh %{berks install --shims}
end

# http://wiki.opscode.com/display/chef/Managing+Cookbooks+With+Knife#ManagingCookbooksWithKnife-test
desc "Test cookbooks via knife"
task :knife do
  sh %{knife cookbook test -o cookbooks -a}
end

# https://github.com/acrmp/chefspec
desc "Run ChefSpec Unit Tests"
task :chefspec do
  sh %{rspec cookbooks/datadog/spec/}
end
