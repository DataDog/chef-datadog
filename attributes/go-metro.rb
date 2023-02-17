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

# The implementation for the go-metro recipe allows any package resource
# property to be defined as an attribute underneath the
# node['datadog']['go-metro']['libcap_package'] namespace
#
# For example, if you want to set the package version, you can do something
# like:
# default['datadog']['go-metro']['libcap_package']['version'] = 'foo'

# The only required option is package_name:
# valid values for RHEL-based system are: libcap, compat-libcap1
# valid values for Debian-based systems are: libcap, libcap2-bin
default['datadog']['go-metro']['libcap_package']['package_name'] = 'libcap'

# init config
default['datadog']['go-metro']['init_config'] = {
  'snaplen' => 512,
  'idle_ttl' => 300,
  'exp_ttl' => 60,
  'statsd_ip' => '127.0.0.1',
  'statsd_port' => 8125,
  'log_to_file' => true,
  'log_level' => 'info'
}
