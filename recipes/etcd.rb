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

include_recipe '::dd-agent'

# Monitor etcd
#
# API endpoint of your etcd instance
# - url: "https://server:port"
#   Change the time to wait on an etcd API request
#   timeout: 5
#
#   If certificate-based authentication of clients is enabled on your etcd server,
#   specify the key file and the certificate file that the check should use.
#   ssl_keyfile: /path/to/key/file
#   ssl_certfile: /path/to/certificate/file
#
#   Set to `false` to disable the validation of the server's SSL certificates (default: true).
#   ssl_cert_validation: true
#
#   If ssl_cert_validation is enabled, you can provide a custom file
#   that lists trusted CA certificates (optional).
#   ssl_ca_certs: /path/to/CA/certificate/file

datadog_monitor 'etcd' do
  instances node['datadog']['etcd']['instances']
  logs node['datadog']['etcd']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
