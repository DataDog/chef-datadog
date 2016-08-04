# Run this recipe to completely remove the Datadog Agent

# On Windows, this recipe works only with Chef >= 12.6

case node['os']
when 'linux'
  package 'datadog-agent' do
    action :purge
  end
when 'windows'
  package 'Datadog Agent' do
    action :remove
  end
end
