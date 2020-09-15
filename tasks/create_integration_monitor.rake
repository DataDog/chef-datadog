require 'rake'
require 'pathname'

begin
  require_relative 'config_specification'

  ### Rake task body
  INTEGRATIONS_CORE_REPO = 'git@github.com:DataDog/integrations-core.git'.freeze
  ROOT_PATH = Pathname.new(File.join(File.dirname(__FILE__), '..')).freeze

  def local_itg_or_clone_in_tmp_dir
    # rubocop:disable Lint/AssignmentInCondition
    if dd_root = ENV['DATADOG_ROOT']
      # rubocop:enable Lint/AssignmentInCondition
      path = File.join(dd_root, 'integrations-core')
      puts "Using DD_ROOT to use core-integrations at '#{path}'"
      return yield Pathname.new(path)
    end

    Dir.mktmpdir do |folder|
      dest_path = Pathname.new(File.join(folder, 'integrations-core'))

      unless system('git', 'clone', INTEGRATIONS_CORE_REPO, dest_path.to_s)
        raise "Couldn't clone integrations-core project into `#{dest_path}`"
      end

      yield dest_path
    end
  end

  def list_matching_specs(core_path, integration_pattern)
    core_path.glob("#{integration_pattern}/assets/configuration/spec.yaml")
  end

  def integration_name_from_spec_path(spec_path)
    steps = spec_path.to_s.split('/')
    # integrations-core is the base folder so the integration name is
    # its child folder
    name_index = steps.index('integrations-core') + 1
    steps[name_index]
  end

  desc 'Create a monitor for given integrations'
  task :create_integration_monitor, [:integration_name] do |_, args|
    integration_pattern = args[:integration_name] || '*'

    local_itg_or_clone_in_tmp_dir do |core_path|
      template_cache = ConfigSpecification::TemplateCache.new(core_path)
      expander = ConfigSpecification::YAMLExpander.new(template_cache)

      matching_specs = list_matching_specs(core_path, integration_pattern)

      puts "Found #{matching_specs.size} matching specifications"

      matching_specs.each do |spec_path|
        current_integration_name = integration_name_from_spec_path(spec_path)

        puts "Loading specification of integration '#{current_integration_name}'"

        expanded_specification = expander.expand(YAML.load_file(spec_path))
        specification = ConfigSpecification::Specification.new(expanded_specification)

        output_path = (ROOT_PATH + "recipes/#{current_integration_name}.rb").cleanpath

        puts "Writing default configuration to #{output_path}"
        recipe = ConfigSpecification::MonitorSerializer.new(specification, current_integration_name).serialize
        File.write(output_path, recipe)
      end
    end
  end
  # rubocop:disable Lint/HandleExceptions
rescue LoadError
end
# rubocop:enable Lint/HandleExceptions
