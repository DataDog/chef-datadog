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

# Integrate jenkins builds
#
# To configure the integration of one or more jenkins servers into Datadog
# simply set up attributes for the jenkins nodes or roles like so:
#
# node.datadog.jenkins.instances = [
#                                   {
#                                     "name" => "dev-jenkins",
#                                     "home" => "/var/lib/jenkins/dev"
#                                   },
#                                   {
#                                     "name" => "prod-jenkins",
#                                     "home" => "/var/lib/jenkins/prod"
#                                   }
#                                  ]
#
# Note that this check can only monitor local jenkins instances

datadog_monitor 'jenkins' do
  instances node['datadog']['jenkins']['instances']
  logs node['datadog']['jenkins']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
