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

module ConfigSpecification
  class MonitorSerializer
    def initialize(specification, integration_name)
      @specification = specification
      @integration_name = integration_name
    end

    def serialize
      %(include_recipe '::dd-agent'

# Monitor #{specification.name}
#
# Here is the description of acceptable attributes:
#{commented_parameters}
datadog_monitor '#{integration_name}' do
  init_config node['datadog']['#{integration_name}']['init_config']
  instances node['datadog']['#{integration_name}']['instances']
  logs node['datadog']['#{integration_name}']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
)
    end

    private

    attr_reader :specification
    attr_reader :integration_name

    def commented_parameters
      "node.datadog.#{integration_name} = #{parameters}".gsub(/^(.*)/, '# \1')
    end

    def parameters
      ParametersSerializer.new(specification, integration_name).serialize
    end
  end
end
