#
# Cookbook Name:: datadog
# Recipe:: dogstatsd-python
#
# Copyright 2013-2015, Datadog
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

# NB: This recipe is compatible with Chef <= 12 only. If you're using Chef 13 or higher
# please refer to the README of the cookbook.

easy_install_package 'dogstatsd-python'
