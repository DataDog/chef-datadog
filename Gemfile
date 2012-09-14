# -*- encoding: utf-8 -*-
source "http://rubygems.org"

chef_version = ENV.key?('CHEF_VERSION') ? "= #{ENV['CHEF_VERSION']}" : ['~> 10']

gem "rake", "~> 0.9"
gem "chef", chef_version

group :development do
  gem "travis-lint", "~> 1.4.0"
  gem "guard", "~> 1.3.2"
  gem "guard-foodcritic", "~> 1.0.0"
  gem "guard-rspec", "~> 1.2.1"
end

group :test do
  gem "tailor", "~> 1.1.2" # Ruby style
  gem "foodcritic", "~> 1.6.1" # Lint testing
  gem "berkshelf", "~> 0.4.0"
  gem "chefspec", "~> 0.7.0"
  gem "fauxhai", "~> 0.0.3"
end
