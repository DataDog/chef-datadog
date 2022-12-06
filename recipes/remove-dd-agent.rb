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

# Run this recipe to completely remove the Datadog Agent

# On Windows, this recipe works only with Chef >= 12.6

case node['os']
when 'linux'
  package 'datadog-agent' do
    action :purge
  end
when 'windows'
  package 'Datadog Agent' do
    action :remove
  end
end
