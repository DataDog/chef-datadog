require 'chefspec'
require 'chefspec/berkshelf'
require 'coveralls'
Coveralls.wear!

require 'json_spec'
require 'yaml'

require 'shared_examples'

RSpec.configure do |config|
  config.berkshelf_options = { except: :integration }

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
    stub_command('apt-key list | grep 382E94DE').and_return(false)
    stub_command('gpg --dry-run --quiet --with-fingerprint /var/chef/cache/DATADOG_RPM_KEY_E09422B3.public'\
    " | grep 'A4C0 B90D 7443 CF6E 4E8A  A341 F106 8E14 E094 22B3'").and_return(true)
    stub_command('rpm -q gpg-pubkey-e09422b3').and_return(false)
  end

  Ohai::Config[:log_level] = :warn
end

ChefSpec::Coverage.start!
