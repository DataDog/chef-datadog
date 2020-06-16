
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
    attribute :value, 'ConfigSpecification::Value'
    attribute :options, Array['ConfigSpecification::Option']
  end

  class Value
    include Virtus.model(finalize: false)

    attribute :type, String
    attribute :example
    attribute :items, 'ConfigSpecification::Value'
  end
end

Virtus.finalize