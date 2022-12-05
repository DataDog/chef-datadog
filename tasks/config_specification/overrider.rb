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
  # Overriding values using the syntax from specification files
  class Overrider
    def initialize(overrides = {})
      @overrides = overrides
    end

    def apply(object)
      overrides.each do |path, value|
        *steps, attribute = path.split('.')

        to_override = descend(object, steps)

        to_override[attribute] = value
      end

      object
    end

    private

    attr_reader :overrides

    def descend(object, steps)
      return object if steps.empty?

      next_step, *further_steps = steps

      sub_object = find_sub_object(object, next_step)

      raise "Cannot browse to #{next_step} on #{object.inspect}" unless sub_object

      descend(sub_object, further_steps)
    end

    def find_sub_object(object, next_step)
      case object
      when Array
        object.detect do |sub_object|
          sub_object['name'].downcase == next_step.downcase
        end
      when Hash
        object[next_step]
      end
    end
  end
end
