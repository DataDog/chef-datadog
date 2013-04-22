# -*- encoding: utf-8 -*-
source "https://rubygems.org"

gem "rake", "~> 10"

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
  gem "chefspec", "~> 1.0.0.rc1" # See https://github.com/acrmp/chefspec/issues/93
end
