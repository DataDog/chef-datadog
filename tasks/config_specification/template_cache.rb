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
  # Bookeeping expanded templates
  class TemplateCache
    SUB_PATH = 'datadog_checks_dev/datadog_checks/dev/tooling/templates/configuration/'.freeze

    def initialize(core_path)
      @templates_path = Pathname.new(core_path) + SUB_PATH
      @templates = {}

      @expander = YAMLExpander.new(self)
    end

    def fetch_template(path)
      unless templates.key?(path)
        # load yaml of template
        template = YAML.load_file(templates_path + "#{path}.yaml")

        # expand template once and for all
        templates[path] = expander.expand(template)
      end

      # making deep_dup of template so that the caller
      # can use it as it wants
      templates[path].deep_dup
    end

    private

    attr_reader :templates
    attr_reader :templates_path
    attr_reader :expander
  end
end
