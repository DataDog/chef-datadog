require 'chefspec'
require 'chefspec/berkshelf'
require 'coveralls'
Coveralls.wear!

require 'json_spec'
require 'yaml'

require 'shared_examples'

RSpec.configure do |config|
  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # run all specs when using a filter, but no spec match
  config.run_all_when_everything_filtered = true

  # Supress deprecation warnings from `yum` cookbook.
  # @see https://github.com/chef-cookbooks/yum/issues/140
  config.log_level = :error

  config.file_cache_path = '/var/chef/cache'

  config.before do
    # recipes/dd-agent.rb
    stub_command('rpm -q datadog-agent-base').and_return(true)
    stub_command('apt-cache policy datadog-agent-base | grep "Installed: (none)"').and_return(false)

    # recipes/repository.rb
    stub_command('rpm -q gpg-pubkey-e09422b3').and_return(false)
  end

  Ohai::Config[:log_level] = :warn
end

ChefSpec::Coverage.start!
