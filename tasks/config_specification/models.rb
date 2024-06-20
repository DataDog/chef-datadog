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
  class Specification
    include Virtus.model(finalize: false)

    attribute :name, String
    attribute :files, Array['ConfigSpecification::Configuration']
  end

  class Configuration
    include Virtus.model(finalize: false)

    attribute :name, String
    attribute :options, Array['ConfigSpecification::Option']

    def canonic_name
      File.basename(name, '.*')
    end
  end

  class Option
    include Virtus.model(finalize: false)

    attribute :name, String
    attribute :description, String
    attribute :required, Boolean
    attribute :value, 'ConfigSpecification::Value'
    attribute :options, Array['ConfigSpecification::Option']

    def comment
      "#{name} - required: #{!!required} ".tap do |comment|
        comment << " - #{value.comment}" if value
      end.strip
    end

    def example
      return unless value

      value.example
    end
  end

  class Value
    include Virtus.model(finalize: false)

    attribute :type, String
    attribute :example
    attribute :items, 'ConfigSpecification::Value'

    def comment
      if items
        "#{type} of #{items.comment}"
      elsif type
        type
      end
    end
  end
end

Virtus.finalize
