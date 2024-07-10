source 'https://rubygems.org'

chef_version = ENV.fetch('CHEF_VERSION', '14.10.9')

gem 'rake'
gem 'rspec-expectations', '< 3.12.4'
gem 'chef', "= #{chef_version}"
gem 'cucumber-core', '~> 3.2.1'
gem 'yaml'
gem 'chefspec'
gem 'berkshelf'
gem 'fauxhai-ng', '~> 8.3.1'
gem 'cookstyle'
gem 'test-kitchen'
gem 'json_spec', '~> 1.1.4'
gem 'kitchen-vagrant'
gem 'kitchen-docker', '~> 2.3.0'
gem 'rbnacl', '~> 4.0.2'
gem 'rbnacl-libsodium', '~> 1.0.16'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
gem 'jaro_winkler', '~> 1.5.6'
gem 'dry-inflector'

if RUBY_VERSION < '2.6.4'
  gem 'term-ansicolor', '~> 1.8.0'
end
gem 'coveralls', '~> 0.8.19'

if RUBY_VERSION >= '3.0.0' && RUBY_VERSION < '3.1.0'
  gem 'uri', '= 0.10.1'
end

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
