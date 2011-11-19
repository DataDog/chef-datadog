#
# Cookbook Name:: datadog
# Recipe:: dd-agent
#
# Copyright 2011, Datadog
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

# Only support Debian & Ubuntu (RedHat et al. coming soon)
case node.platform
when "debian", "ubuntu"
  
  apt_repository 'datadog' do
    keyserver 'keyserver.ubuntu.com'
    key 'C7A7DA52'
    uri node[:datadog][:repo]
    distribution "unstable"
    components ["main"]
    action :add
  end

  package 'datadog-agent'

  service "datadog-agent" do
    action :enable
    supports :restart => true
  end

  directory "/etc/dd-agent" do
      owner "root"
      group "root"
      mode 0755
  end

  if node.attribute?("datadog") and node.datadog.attribute?("api_key")
      template "/etc/dd-agent/datadog.conf" do
          owner "root"
          group "root"
          mode 0644
          variables(:api_key => node[:datadog][:api_key], :dd_url => node[:datadog][:url])
          notifies :restart, "service[datadog-agent]", :immediately
      end
  else
      raise "Add a [:datadog][:api_key] attribute to configure this node's Datadog Agent."
  end
end
