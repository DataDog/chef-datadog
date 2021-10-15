class Chef
  # Helper class for Datadog Chef recipes
  class Datadog
    class << self
      ACCEPTABLE_AGENT_FLAVORS = %w[
        datadog-agent
        datadog-iot-agent
      ].freeze

      def agent_version(node)
        dd_agent_version = node['datadog']['agent_version']
        if dd_agent_version.respond_to?(:each_pair)
          platform_family = node['platform_family']
          # Unless explicitly listed, treat fedora and amazon as rhel
          if !dd_agent_version.include?(platform_family) && ['fedora', 'amazon'].include?(platform_family)
            platform_family = 'rhel'
          end
          dd_agent_version = dd_agent_version[platform_family]
        end
        if !dd_agent_version.nil? && dd_agent_version.match(/^[0-9]+\.[0-9]+\.[0-9]+((?:~|-)[^0-9\s-]+[^-\s]*)?$/)
          if node['platform_family'] == 'suse' || node['platform_family'] == 'debian'
            dd_agent_version = '1:' + dd_agent_version + '-1'
          elsif node['platform_family'] == 'rhel' || node['platform_family'] == 'fedora' || node['platform_family'] == 'amazon'
            dd_agent_version += '-1'
          end
        end
        dd_agent_version
      end

      def agent_major_version(node)
        # user-specified values
        agent_major_version = node['datadog']['agent_major_version']
        agent_version = agent_version(node)

        unless agent_version.nil?
          match = agent_version.match(/([0-9]+:)?([0-9]+)\.([0-9]+)\.([0-9]+)([^-\s]+)?(?:-([0-9]+))?/)
          if match.nil?
            Chef::Log.warn "Couldn't infer agent_major_version from agent_version '#{agent_version}'"
          else
            _epoch, major, _minor, _patch, _suffix, _release = match.captures
            if !agent_major_version.nil? && major.to_i != agent_major_version.to_i
              raise "Provided (#{agent_major_version}) and deduced (#{major}) agent_major_version don't match"
            end
            return major.to_i
          end
        end

        return agent_major_version.to_i unless agent_major_version.nil?

        # default to Agent 7
        node.default['datadog']['agent_major_version'] = 7
        7
      end

      def agent_minor_version(node)
        agent_version = agent_version(node)
        unless agent_version.nil?
          match = agent_version.match(/([0-9]+:)?([0-9]+)\.([0-9]+)\.([0-9]+)([^-\s]+)?(?:-([0-9]+))?/)
          if match.nil?
            Chef::Log.warn "Couldn't infer agent_minor_version from agent_version '#{agent_version}'"
          else
            _epoch, _major, minor, _patch, _suffix, _release = match.captures
            return minor.to_i
          end
        end
        nil
      end

      def agent_flavor(node)
        # user-specified values
        agent_flavor = node['datadog']['agent_flavor']
        agent_flavor ||= node.default['datadog']['agent_flavor']

        unless ACCEPTABLE_AGENT_FLAVORS.include?(agent_flavor)
          raise "Unknown agent flavor '#{agent_flavor}' (acceptable values: #{ACCEPTABLE_AGENT_FLAVORS.inspect})"
        end

        agent_flavor
      end

      def api_key(node)
        run_state_or_attribute(node, 'api_key')
      end

      def application_key(node)
        run_state_or_attribute(node, 'application_key')
      end

      def ddagentuser_name(node)
        run_state_or_attribute(node, 'windows_ddagentuser_name')
      end

      def ddagentuser_password(node)
        run_state_or_attribute(node, 'windows_ddagentuser_password')
      end

      def npm_install(node)
        run_state_or_attribute(node, 'windows_npm_install') || run_state_or_attribute_system_probe(node, 'network_enabled')
      end

      def cookbook_version(run_context)
        run_context.cookbook_collection['datadog'].version
      end

      def upstart_platform?(node)
        agent_major_version(node) > 5 &&
          (((node['platform'] == 'amazon' || node['platform_family'] == 'amazon') && node['platform_version'].to_i != 2) ||
           (node['platform'] == 'ubuntu' && node['platform_version'].to_f < 15.04) || # chef <11.14 doesn't use the correct service provider
          (node['platform'] != 'amazon' && node['platform_family'] == 'rhel' && node['platform_version'].to_i < 7))
      end

      def service_provider(node)
        if node['datadog']['service_provider']
          specified_provider = node['datadog']['service_provider']
          if Chef::Provider::Service.constants.include?(specified_provider.to_sym)
            service_provider = Chef::Provider::Service.const_get(specified_provider)
          end
          service_provider
        elsif upstart_platform?(node)
          Chef::Provider::Service::Upstart
        end
      end

      private

      def run_state_or_attribute(node, attribute)
        if node.run_state.key?('datadog') && node.run_state['datadog'].key?(attribute)
          node.run_state['datadog'][attribute]
        else
          node['datadog'][attribute]
        end
      end

      def run_state_or_attribute_system_probe(node, attribute)
        if node.run_state.key?('datadog') && node.run_state['datadog'].key?('system_probe') && node.run_state['datadog']['system_probe'].key?(attribute)
          node.run_state['datadog']['system_probe'][attribute]
        else
          node['datadog']['system_probe'][attribute]
        end
      end
    end

    module WindowsInstallHelpers
      WIN_BIN_PATH = 'C:/Program Files/Datadog/Datadog Agent/bin/agent'.freeze

      class << self
        def must_reinstall?(node)
          current_version = fetch_current_version
          target_version = requested_agent_version(node)

          return false unless chef_version_can_uninstall?
          return false unless current_version && target_version

          target_version < current_version
        end

        private

        include Chef::Mixin::ShellOut
        def agent_status
          return nil unless File.exist?(WIN_BIN_PATH)
          shell_out("\"#{WIN_BIN_PATH}\" status").stdout.strip
        end

        def fetch_current_version
          status = agent_status
          return nil if status.nil?
          match_data = status.match(/^Agent \(v(.*)\)/)

          # Nightlies like 6.20.0-devel+git.38.cd7f989 fail to parse as Gem::Version because of the '+' sign
          version = match_data[1].tr('+', '-') if match_data

          Gem::Version.new(version) if version
        end

        def requested_agent_version(node)
          version = Chef::Datadog.agent_version(node)
          return nil unless version

          cleaned = version.scan(/\d+\.\d+\.\d+/).first
          Gem::Version.new(cleaned) if cleaned
        end

        def chef_version_can_uninstall?
          # Chef versions previous to 14 cannot correctly uninstall the agent
          # because they cannot correctly fetch the registry keys of 64 bits
          # applications for uninstallation so we are only using the downgrade
          # feature on chef >= to 14
          Gem::Requirement.new('>= 14').satisfied_by?(Gem::Version.new(Chef::VERSION))
        end
      end
    end
  end
end
