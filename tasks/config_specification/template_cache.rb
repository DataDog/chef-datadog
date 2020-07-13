
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
