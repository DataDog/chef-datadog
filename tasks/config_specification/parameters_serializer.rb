module ConfigSpecification
  class ParametersSerializer
    def initialize(specification, integration_name)
      @specification = specification
      @integration_name = integration_name
    end

    def serialize
      if specification.files.size > 1
        puts "! WARNING: Found more than one file in spec for #{integration_name}: #{specification.files.map(&:canonic_name).join(', ')}"
      end
      file = specification.files.find { |f| f.canonic_name == integration_name }
      if file.nil?
        file = specification.files.first
        puts "! WARNING: Found no file named #{integration_name} in spec, will use #{file.canonic_name} instead"
      end
      dump_options(file.options)
    end

    private

    attr_reader :specification
    attr_reader :integration_name

    def dump_options(options, indent: 0)
      buffer = ' ' * indent
      buffer << "{\n"

      options.each do |option|
        # Add comment
        buffer << ' ' * (indent + 2)
        buffer << "# #{option.comment}\n"

        # Add option example
        buffer << ' ' * (indent + 2)
        buffer << option.name.inspect
        buffer << ' => '

        # if this an aggregation of options
        # dump sub options
        if (sub_options = option.options) && sub_options.any?
          # edge case to wrap instances into an array as specs
          # do not describe it as such
          if option.name == 'instances'
            buffer << "[\n"
            buffer << ' ' * (indent + 4)
            buffer << dump_options(sub_options, indent: indent + 4).strip
            buffer << ",\n"
            buffer << ' ' * (indent + 2)
            buffer << ']'
          else
            buffer << dump_options(sub_options, indent: indent + 2).strip
          end
        else
          # otherwise, print example value of option
          buffer << dump_value(option.example, indent: indent + 2).strip
        end

        buffer << ",\n"
      end

      buffer << ' ' * indent
      buffer << "}\n"

      buffer
    end

    def dump_value(object, indent: 0)
      buffer = ' ' * indent

      case object
      when Array
        buffer << "[\n"
        object.each do |sub_object|
          buffer << dump_value(sub_object, indent: indent + 2).rstrip
          buffer << ",\n"
        end
        buffer << ' ' * indent
        buffer << "]\n"
      when Hash
        buffer << "{\n"
        object.each do |config_name, config_value|
          buffer << ' ' * (indent + 2)
          buffer << config_name.inspect
          buffer << ' => '
          buffer << dump_value(config_value, indent: indent + 2).strip
          buffer << ",\n"
        end
        buffer << ' ' * indent
        buffer << "}\n"
      else
        buffer << object.inspect
      end

      buffer
    end
  end
end
