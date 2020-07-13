module ConfigSpecification
  class ParametersSerializer
    def initialize(specification)
      @specification = specification
    end

    def serialize
      specification.files.each_with_object({}) do |file, parameters|
        parameters[file.canonic_name] = dump_options(file.options)
      end
    end

    private

    attr_reader :specification

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
          buffer << dump_value(sub_object, indent: indent + 2)
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
