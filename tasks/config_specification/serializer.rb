# rubocop:disable Lint/AssignmentInCondition
module ConfigSpecification
  class Serializer
    def initialize(specification)
      @specification = specification
    end

    def write_to(path)
      parameters = build_parameters

      parameters.each do |filename, categories|
        # edge case to make instances plural (hash to array)
        if instances = categories['instances']
          categories['instances'] = Array.wrap(instances)
        end

        File.open(path, 'w+') do |defaults|
          categories.each do |category, category_value|
            defaults << "default['datadog']['#{filename}']['#{category}'] = #{value(category_value)}\n"
          end
        end
      end
    end

    private

    attr_reader :specification

    def build_parameters
      specification.files.each_with_object({}) do |file, parameters|
        parameters[file.canonic_name] = file.options.each_with_object({}) do |option, collector|
          dump_option(option, collector)
        end
      end
    end

    def dump_option(option, collector)
      return if skipped?(option)

      if option.options.any?
        collector[option.name] = option.options.each_with_object({}) do |sub_option, sub_collector|
          dump_option(sub_option, sub_collector)
        end
      elsif option.value && !(example = option.value.example).nil?
        collector[option.name] = example
        # or else we don't dump the option
      end
    end

    BLACKLISTED_NAMES = %w[tags service].freeze

    def skipped?(option)
      return true if BLACKLISTED_NAMES.include?(option.name.downcase)

      if value = option.value
        return true if value.type == 'array'
        return true if value.type == 'object'

        if example = value.example
          return true if /<\w+>/.match?(example.inspect)
        end
      end

      false
    end

    def value(object, indent: 0)
      buffer = ' ' * indent

      case object
      when Array
        buffer << "[\n"
        buffer << object.map do |sub_object|
          value(sub_object, indent: indent + 2)
        end.join(",\n")
        buffer << ' ' * indent
        buffer << "]\n"
      when Hash
        buffer << "{\n"
        object.each do |config_name, config_value|
          buffer << ' ' * (indent + 2)
          buffer << config_name.inspect
          buffer << ' => '
          buffer << value(config_value, indent: indent + 2).strip
          buffer << ",\n"
        end
        buffer << "}\n"
      else
        buffer << object.inspect
      end

      buffer
    end
  end
end
# rubocop:enable Lint/AssignmentInCondition
