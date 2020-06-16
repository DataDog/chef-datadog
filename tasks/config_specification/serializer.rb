
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
      else
        if (example = option&.value&.example) != nil
          collector[option.name] = example
        end
      end
    end

    BLACKLISTED_NAMES = %w(tags service)

    def skipped?(option)
      return true if BLACKLISTED_NAMES.include?(option.name.downcase)

      return true if option&.value&.type == 'array'
      return true if option&.value&.type == 'object'

      if example = option&.value&.example
        return true if /<\w+>/.match?(example.inspect)
      end

      false
    end

    def value(object, indent: 0)
      buffer = String.new

      case object
      when Array
        buffer << ' ' * indent
        buffer << "[\n"
        buffer << object.map do |sub_object|
          value(sub_object, indent: indent + 2)
        end.join(",\n")
        buffer << ' ' * indent
        buffer << "]\n"
      when Hash
        buffer << ' ' * indent
        buffer << "{\n"
        object.each do |config_name, config_value|
          buffer << ' ' * (indent + 2)
          buffer << config_name.inspect
          buffer << ' => '
          buffer << value(config_value, indent: indent + 2).strip
          buffer << ",\n"
        end
        buffer << ' ' * indent
        buffer << "}\n"
      else
        buffer << ' ' * indent
        buffer << object.inspect
      end

      buffer
    end
  end
end