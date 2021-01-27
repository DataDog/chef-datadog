source 'https://rubygems.org'

chef_version = ENV.fetch('CHEF_VERSION', '14.10.9')

gem 'rake'
gem 'chef', "= #{chef_version}"
gem 'cucumber-core', '~> 3.2.1'
gem 'yaml'
gem 'chefspec'
gem 'berkshelf'
gem 'fauxhai-ng', '~> 7.5.1'
gem 'cookstyle'
gem 'coveralls', '~> 0.8.19'
gem 'test-kitchen'
gem 'json_spec', '~> 1.1.4'
gem 'kitchen-vagrant'
gem 'kitchen-docker', '~> 2.3.0'

if RUBY_VERSION < '2.4'
  gem 'json', '~> 2.4.1'
end

gem 'foodcritic', (RUBY_VERSION >= '2.4' ? '~> 16.3.0' : '~> 11.4.0')
gem 'rubocop', (RUBY_VERSION >= '2.4' ? '~> 0.80.1' : '~> 0.49.1')

if Gem::Version.new(chef_version) >= Gem::Version.new('14.10.9')
  group :development do
    gem 'activesupport', '~> 6.0.3'
    gem 'virtus'
    gem 'inflecto'
  end
end
