#!/usr/bin/env rake

require 'emeril/rake' unless ENV['CI']
require 'fileutils'
require 'foodcritic'
require 'kitchen/rake_tasks'
require 'rake/clean'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task :default => [
  :style,
  :spec
]

CLEAN.include %w(.kitchen/ .yardoc/ coverage/)
CLOBBER.include %w(doc/ Berksfile.lock Gemfile.lock)

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = { fail_tags: ['correctness'] }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

# Rspec and ChefSpec
desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

namespace :generate do
  desc 'Create an integration kitchen test template'
  task :test_suite, :recipe_name do |_, arg|
    gemfile_relative_path = '../../helpers/serverspec/Gemfile'
    sspec_template = "#{Dir.pwd}/test/integration/helpers/serverspec/spec_template.rb"

    suite_name = "datadog_#{arg['recipe_name']}"
    spec_name = "#{arg['recipe_name']}_spec.rb"

    suite_dir = File.join(Dir.pwd, 'test/integration', suite_name)
    sspec_dir = File.join(suite_dir, 'serverspec')

    if Dir.exist? suite_dir
      abort("Test directory named '#{suite_name}' exists!")
    else
      FileUtils.makedirs(sspec_dir)
    end

    FileUtils.copy(sspec_template, File.join(sspec_dir, spec_name))

    # Symlinks need to be relative paths to work cross-system
    Dir.chdir(sspec_dir) do
      FileUtils.symlink(gemfile_relative_path, 'Gemfile')
    end

    suite_name.tr!('_', '-')

    puts <<-EOT.sub(/\n$/, '')
      New test suite created!
      Next steps:
      - Add a new entry to .kitchen.yml
      - Modify #{spec_name} in #{sspec_dir}
      - Run `kitchen list #{suite_name}` to confirm suite added.
      - Run `kitchen test #{suite_name}` to run tests.
    EOT
  end
end

desc 'Run Kitchen tests using CircleCI parallelism mode, split by platform'
task :circle do
  # Load environment-defined config
  def kitchen_loader
    Kitchen::Loader::YAML.new(local_config: ENV['KITCHEN_LOCAL_YAML'])
  end

  def kitchen_config
    Kitchen::Config.new(loader: kitchen_loader)
  end

  def total_workers
    ENV['CIRCLE_NODE_TOTAL'].to_i
  end

  def current_worker
    ENV['CIRCLE_NODE_INDEX'].to_i
  end

  def command
    commands = []

    kitchen_config.platforms.sort_by(&:name).each_with_index do |platform, index|
      next unless index % total_workers == current_worker
      # Escape the platform name to somehting the CLI will understand.
      # TODO: This could likely be pulled from kitchen_config.instances somehow
      name = platform.name.delete('.')

      # Scope the suites to only execute against the Agent installer suites.
      commands.push "kitchen verify dd-agent-handler-#{name}"
    end

    commands.join(' && ')
  end

  sh command unless command.empty?
end
