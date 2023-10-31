# Copyright:: 2011-Present, Datadog
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class Chef
  # Helper class for Datadog Chef recipes
  class Datadog
    class << self
      ACCEPTABLE_AGENT_FLAVORS = %w[
        datadog-agent
        datadog-iot-agent
      ].freeze

      # This method stores a variable that is used across recipes so we needed a place to define it.
      # Global variables like this are usually set in the attributes/default.rb file for users to edit them.
      # We don't want this variable to be changed by the user though, hence the place.
      def apt_sources_list_file
        '/etc/apt/sources.list.d/datadog.list'
      end

      def chef_version_ge?(version)
        Gem::Requirement.new(">= #{version}").satisfied_by?(Gem::Version.new(Chef::VERSION))
      end

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
          # For RHEL-based distros:
          # - we can only add epoch and release when running Chef >= 14, as Chef < 14
          # has different yum logic that doesn't know how to work with epoch and release
          # - for Chef < 14, we only add release
          if %w[debian suse].include?(node['platform_family']) ||
             (%w[amazon fedora rhel].include?(node['platform_family']) && chef_version_ge?(14))
            dd_agent_version = '1:' + dd_agent_version + '-1'
          elsif %w[amazon fedora rhel].include?(node['platform_family'])
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

      def systemd_platform?(node)
        (node['platform'] == 'amazon' || node['platform_family'] == 'amazon') && node['platform_version'].to_i >= 2022
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
        # Specific catch for Amazon Linux >= 2022 where Upstart doesn't work
        elsif systemd_platform?(node)
          Chef::Provider::Service::Systemd
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
        def agent_get_version
          return nil unless File.file?(WIN_BIN_PATH)
          shell_out("\"#{WIN_BIN_PATH}\" version -n").stdout.strip
        end

        def fetch_current_version
          raw_version = agent_get_version
          return nil if raw_version.nil?
          match_data = raw_version.match(/^Agent ([^\s]*) (- Meta: ([^\s]*) )?- Commit/)
          # will fail if raw_version is empty (Line 199 fails)
          version = match_data[1] if match_data
          nightly_version = match_data[3] if match_data[2]
          # If the Meta tag is catched, we'll add it to the version to specify the nightly version we're using
          # Nightlies like 6.20.0-devel+git.38.cd7f989 fail to parse as Gem::Version because of the '+' sign so let's use '-'
          version = version + '-' + nightly_version if nightly_version

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
          Chef::Datadog.chef_version_ge? 14
        end
      end
    end
  end
end
