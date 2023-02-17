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

datadog_integration 'datadog-aerospike' do
  action :remove
  notifies :restart, 'service[datadog-agent]'
end
# This time Chef should mention "up to date"
datadog_integration 'datadog-aerospike' do
  action :remove
end
datadog_integration 'datadog-aerospike' do
  action :install
  version '1.2.0'
end
# This time Chef should mention "up to date"
datadog_integration 'datadog-aerospike' do
  action :install
  version '1.2.0'
end

datadog_integration 'datadog-elastic' do
  action :remove
  notifies :restart, 'service[datadog-agent]'
end
# This time Chef should mention "up to date"
datadog_integration 'datadog-elastic' do
  action :remove
end
datadog_integration 'datadog-elastic' do
  action :install
  version '1.11.0'
end
# This time Chef should mention "up to date"
datadog_integration 'datadog-elastic' do
  action :install
  version '1.11.0'
end
