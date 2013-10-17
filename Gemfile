# -*- encoding: utf-8 -*-
source "https://rubygems.org"

gem "rake", "~> 10.1"

group :development do
  gem "travis-lint", "~> 1.4"
  gem "guard", "~> 1.3"
  gem "guard-foodcritic", "~> 1.0.1"
  gem "guard-rspec", "~> 3.0"
end

group :test do
  gem "tailor", "~> 1.3" # Ruby style
  gem "foodcritic", "~> 2.1" # Lint testing
  gem "berkshelf", "~> 2.0"
  gem "chefspec", "~> 1.0"
end

group :vagrant do
  gem "test-kitchen",  "1.0.0.beta.2"
  gem 'kitchen-vagrant'
end
