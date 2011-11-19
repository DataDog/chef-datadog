#
# Cookbook Name:: datadog
# Attributes:: default
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

# Place your API Key here, or set it on the role/environment/node
default[:datadog][:api_key] = nil

# Create an appliaction key on the Account Settings page
default[:datadog][:application_key] = nil

# Don't change these
default[:datadog][:url] = "https://app.datadoghq.com"
default[:datadog][:repo] = "http://apt.datadoghq.com"
