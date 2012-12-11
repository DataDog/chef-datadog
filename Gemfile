# -*- encoding: utf-8 -*-
source "http://rubygems.org"

chef_version = ENV.key?('CHEF_VERSION') ? "= #{ENV['CHEF_VERSION']}" : ['~> 10']

gem "rake", "~> 10"
gem "chef", chef_version

group :development do
  gem "travis-lint", "~> 1.4"
  gem "guard", "~> 1.3"
  gem "guard-foodcritic", "~> 1.0"
  gem "guard-rspec", "~> 2.3"
end

group :test do
  gem "tailor", "~> 1.1" # Ruby style
  gem "foodcritic", "~> 1.6" # Lint testing
  gem "berkshelf", "~> 1.0"
  gem "chefspec", "~> 0.7"
  gem "fauxhai", "~> 0.0"
end
