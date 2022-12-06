# Copyright:: 2011-Present, Datadog
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Configure a service via its yaml file

# enable unified mode on specific Chef versions.
# See CHEF-33 Deprecation warning:
# https://docs.chef.io/deprecations_unified_mode/

unified_mode true if respond_to?(:unified_mode)

require 'yaml' # Our erb templates need this

default_action :add

property :cookbook, String, default: 'datadog'

# checks have 3 sections: init_config, instances, logs
# we mimic these here, no validation is performed until the template
# is evaluated.
property :init_config, [Hash, nil], required: false, default: {}
property :instances, Array, required: false, default: []
property :version, [Integer, nil], required: false, default: nil
property :use_integration_template, [TrueClass, FalseClass], required: false, default: false
property :is_jmx, [TrueClass, FalseClass], required: false, default: false
property :logs, [Array, nil], required: false, default: []

action :add do
  Chef::Log.debug("Adding monitoring for #{new_resource.name}")

  if Chef::Datadog.agent_major_version(node) != 5
    directory ::File.join(yaml_dir, "#{new_resource.name}.d") do
      if platform_family?('windows')
        inherits true # Agent 6/7 rely on inheritance being enabled. Reset it in case it was disabled when installing Agent 5.
      else
        owner 'dd-agent'
        group 'dd-agent'
        mode '755'
      end
    end
    yaml_file = ::File.join(yaml_dir, "#{new_resource.name}.d", 'conf.yaml')
  else
    yaml_file = ::File.join(yaml_dir, "#{new_resource.name}.yaml")
  end

  template yaml_file do
    # On Windows Agent v5, set the permissions on conf files to Administrators.
    if platform_family?('windows')
      if Chef::Datadog.agent_major_version(node) > 5
        inherits true # Agent 6/7 rely on inheritance being enabled. Reset it in case it was disabled when installing Agent 5.
      else
        owner 'Administrators'
        rights :full_control, 'Administrators'
        inherits false
      end
    else
      owner 'dd-agent'
      mode '600'
    end

    if new_resource.use_integration_template
      source 'integration.yaml.erb'
    else
      source "#{new_resource.name}.yaml.erb"
    end

    init_config = new_resource.init_config
    if new_resource.is_jmx
      init_config ||= {}
      init_config.merge!({ 'is_jmx': true, 'collect_default_metrics': true })
    end

    variables(
      init_config: init_config,
      instances:   new_resource.instances,
      version:     new_resource.version,
      logs:        new_resource.logs
    )
    cookbook new_resource.cookbook
    sensitive true
  end

  if Chef::Datadog.agent_major_version(node) != 5
    file old_mono_config_file_path(new_resource.name) do
      action :delete
      sensitive true
    end
  end
end

action :remove do
  yaml_file = if Chef::Datadog.agent_major_version(node) != 5
                ::File.join(yaml_dir, "#{new_resource.name}.d", 'conf.yaml')
              else
                ::File.join(yaml_dir, "#{new_resource.name}.yaml")
              end

  Chef::Log.debug("Removing #{yaml_file}")

  file yaml_file do
    action :delete
    sensitive true
  end
end

def yaml_dir
  is_agent5 = Chef::Datadog.agent_major_version(node) == 5
  is_windows = platform_family?('windows')
  if is_windows
    "#{ENV['ProgramData']}/Datadog/conf.d"
  else
    is_agent5 ? '/etc/dd-agent/conf.d' : '/etc/datadog-agent/conf.d'
  end
end

def old_mono_config_file_path(resource_name)
  ::File.join(
    yaml_dir,
    "#{resource_name}.yaml"
  )
end
