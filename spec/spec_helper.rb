# Copyright:: 2011-Present, Datadog
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'chefspec'
require 'chefspec/berkshelf'
require 'coveralls'
Coveralls.wear!

require 'json_spec'
require 'yaml'

require 'shared_examples'

def min_chef_version(version)
  Gem.loaded_specs['chef'].version > Gem::Version.new(version)
end

RSpec.configure do |config|
  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # run all specs when using a filter, but no spec match
  config.run_all_when_everything_filtered = true

  # Supress deprecation warnings from `yum` cookbook.
  # @see https://github.com/chef-cookbooks/yum/issues/140
  config.log_level = :error

  config.file_cache_path = Chef::Config[:file_cache_path]

  config.before do
    # recipes/dd-agent.rb
    stub_command('rpm -q datadog-agent-base').and_return(true)
    stub_command('apt-cache policy datadog-agent-base | grep "Installed: (none)"').and_return(false)

    # recipes/repository.rb
    stub_command('rpm -q gpg-pubkey-current').and_return(false)
    stub_command('rpm -q gpg-pubkey-e09422b3').and_return(false)
    stub_command('rpm -q gpg-pubkey-fd4bf915').and_return(false)
    stub_command('rpm -q gpg-pubkey-b01082d3').and_return(false)
    stub_command('rpm -q gpg-pubkey-4172a230-55dd14f6').and_return(true)
    stub_command('apt-key adv --list-public-keys --with-fingerprint --with-colons | grep 382E94DE | grep pub').and_return(false)
  end

  Ohai::Config[:log_level] = :warn
end

ChefSpec::Coverage.start!
