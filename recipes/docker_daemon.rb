#
# Cookbook:: datadog
# Recipe:: docker_daemon
#
# Copyright:: 2011-2016, Datadog
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
include_recipe 'datadog::dd-agent'

# The docker_daemon check no longer exists in agent version 6.x.
# Please use the docker check instead.

# Build a data structure with configuration.
# @see http://docs.datadoghq.com/integrations/docker/
# @example
#   node.override['datadog']['docker_daemon']['init_config'] = {
#     docker_root: '/',
#     socket_timeout: 10,
#     tls: false,
#     tls_client_cert: '/path/to/client-cert.pem',
#     tls_client_key: '/path/to/client-key.pem',
#     tls_cacert: '/path/to/ca.pem',
#     tls_verify: true
#   }
#   node.override['datadog']['docker_daemon']['instances'] = [
#     {
#       url: 'unix://var/run/docker.sock',
#       tags: [
#         'toto',
#         'tata'
#       ],
#       include: [
#         'docker_image:ubuntu',
#         'docker_image:debian'
#       ],
#       exclude: [
#         '.*'
#       ],
#       performance_tags: [
#         'container_name',
#         'image_name',
#         'image_tag',
#         'docker_image'
#       ],
#       container_tags: [
#         'image_name',
#         'image_tag',
#         'docker_image'
#       ],
#       collect_labels_as_tags: [
#         'com.docker.compose.service',
#         'com.docker.compose.project'
#       ],
#       ecs_tags: true,
#       collect_events: true,
#       collect_container_size: false,
#       collect_image_size: false,
#       collect_images_stats: false
#     }
#   ]

group 'docker' do
  action :manage
  append true
  members 'dd-agent'
end

datadog_monitor 'docker_daemon' do
  init_config node['datadog']['docker_daemon']['init_config']
  instances node['datadog']['docker_daemon']['instances']
  logs node['datadog']['docker_daemon']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
