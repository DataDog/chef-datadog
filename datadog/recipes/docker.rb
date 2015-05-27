#
# Cookbook Name:: datadog
# Recipe:: docker
#
# Copyright 2011-2015, Datadog
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

# Build a data structure with configuration.
# @see https://www.datadoghq.com/2014/06/monitor-docker-datadog/
# @example
#   node.override['datadog']['docker']['instances'] = [
#     {
#       url: 'unix://var/run/docker.sock',
#       new_tag_names: 'false',
#       tag_by_command: 'false',
#       tags: ['toto', 'tata'],
#       include: ['docker_image:ubuntu', 'docker_image:debian'],
#       exclude: ['.*'],
#       collect_events: 'true',
#       collect_container_size: 'false',
#       collect_all_metrics: 'false',
#       collect_images_stats: 'false'
#     }
#   ]

datadog_monitor 'docker' do
  init_config node['datadog']['docker']['init_config']
  instances node['datadog']['docker']['instances']
end
