
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
