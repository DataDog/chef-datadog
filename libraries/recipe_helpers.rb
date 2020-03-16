class Chef
  # Helper class for Datadog Chef recipes
  class Datadog
    class << self
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

        if !agent_version.nil?
          _epoch, major, _minor, _patch, _suffix, _release = agent_version.match(/([0-9]+:)?([0-9]+)\.([0-9]+)\.([0-9]+)([^-\s]+)?(?:-([0-9]+))?/).captures
          if !agent_major_version.nil? && major.to_i != agent_major_version.to_i
            raise "Provided (#{agent_major_version}) and deduced (#{major}) agent_major_version don't match"
          end
          ret = major.to_i
        elsif !agent_major_version.nil?
          ret = agent_major_version.to_i
        else
          # default to Agent 7
          node.default['datadog']['agent_major_version'] = 7
          ret = 7
        end
        ret
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

      private

      def run_state_or_attribute(node, attribute)
        if node.run_state.key?('datadog') && node.run_state['datadog'].key?(attribute)
          node.run_state['datadog'][attribute]
        else
          node['datadog'][attribute]
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

        def fetch_current_version
          return nil unless File.exist?(WIN_BIN_PATH)

          agent_status = `"#{WIN_BIN_PATH}" status`
          match_data = agent_status.match(/^Agent \(v(.*)\)/)

          Gem::Version.new(match_data[1]) if match_data
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
