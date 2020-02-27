require 'chef/handler'
require 'chef/log'

module Windows
  class Helper
    def do_cleanup(context)
      Chef::Log.info 'Cleanup started.'
      resource = context.resource_collection.lookup("windows_env[DDAGENTUSER_NAME]")
      resource.run_action(:delete) if resource
      resource = context.resource_collection.lookup("windows_env[DDAGENTUSER_PASSWORD]")
      resource.run_action(:delete) if resource
      Chef::Log.info 'Cleanup finished.'
    end
  end
end