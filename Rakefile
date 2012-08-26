#!/usr/bin/env rake

require 'foodcritic'

task :default => [:foodcritic]

FoodCritic::Rake::LintTask.new do |t|
  t.options = {:fail_tags => ['correctness']}
  t.options = {:chef_version => '0.10.8'}
end
