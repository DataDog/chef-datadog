# Run this recipe to completely remove the Datadog Agent

# On Windows, this recipe works only with Chef >= 12.6

# Importing apt_sources_list_file variable from recipe_helpers.rb
apt_sources_list_file = Chef::Datadog.apt_sources_list_file

case node['os']
when 'linux'
  # Removing the apt sources list file and datadog-signing-keys
  case node['platform_family']
  when 'amazon', 'redhat' # RedHat, CentOS, Rocky?, Almalinux?, Scientific Linux? AND Amazon Linux
    yum_repository 'datadog' do
      action :delete
    end
  when 'debian' # Debian, Ubuntu
    apt_package 'datadog-signing-keys' do
      action :purge
    end
    file apt_sources_list_file do
      action :delete
    end
  when 'suse'
    zypper_repository 'datadog' do
      action :remove
    end
  end
  package 'datadog-agent' do
    action :purge
  end
when 'windows'
  package 'Datadog Agent' do
    action :remove
  end
end
