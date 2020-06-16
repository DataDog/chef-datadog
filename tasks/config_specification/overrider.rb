
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
