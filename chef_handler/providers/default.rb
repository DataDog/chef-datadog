#
# Author:: Seth Chisamore <schisamo@chef.io>
# Cookbook Name:: chef_handler
# Provider:: default
#
# Copyright:: 2011-2013, Chef Software, Inc <legal@chef.io>
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
#

include ::ChefHandler::Helpers

def whyrun_supported?
  true
end

# This action needs to find an rb file that presumably contains the indicated class in it and the
# load that file.  It needs to do this keeping in mind that the same handler class can get enabled
# and disabled multiple times and there may be multiple instances of them running around.  The
# handler code may also have changed between actions.  To handle all this, we parse the full class
# name and attempt to find its class object, in case it has already been loaded.  If such a class
# is found, we then attempt to unload that class before we load the file requested.  We use "load"
# instead of "require" because we want to reload the handler class in case it has changed and
# don't want the caching behavior of "require".
#
# Note that during this process, we also need to keep track of the current handler configuration.
# Any of the above steps might fail - in which case we would not want to be in a situation where
# we have a registered handler that has been unloaded or mangled.
action :enable do
  class_name = new_resource.class_name
  new_resource.supports.each do |type, enable|
    if enable
      converge_by("disable #{class_name} as a #{type} handler") do
        unregister_handler(type, class_name)
      end
    end
  end
  handler = nil
  converge_by("load #{class_name} from #{new_resource.source}") do
    klass = reload_class(class_name, new_resource.source)
    handler = klass.send(:new, *collect_args(new_resource.arguments))
  end
  new_resource.supports.each do |type, enable|
    if enable
      converge_by("enable #{new_resource} as a #{type} handler") do
        register_handler(type, handler)
      end
    end
  end
end

action :disable do
  new_resource.supports.each_key do |type|
    converge_by("disable #{new_resource} as a #{type} handler") do
      unregister_handler(type, new_resource.class_name)
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::ChefHandler.new(new_resource.name)
  @current_resource.class_name(new_resource.class_name)
  @current_resource.source(new_resource.source)
  @current_resource
end

private

def collect_args(resource_args = [])
  if resource_args.is_a? Array
    resource_args
  else
    [resource_args]
  end
end

