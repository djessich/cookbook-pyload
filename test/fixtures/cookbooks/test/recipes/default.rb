#
# Cookbook:: test
# Recipe:: default
#
# Copyright:: 2020, Dominik Jessich
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

# Dokken images don't have all locales available so this is a workaround
locale = value_for_platform(
  centos: { default: node['platform_version'].to_i < 8 ? 'en_US.UTF-8' : 'C.UTF-8' },
  default: 'C.UTF-8'
)

pyload_install 'default' do
  notifies :restart, 'pyload_service[default]', :delayed
end

pyload_config 'default' do
  notifies :restart, 'pyload_service[default]', :delayed
end

pyload_service 'default' do
  env_vars(
    'LANG' => locale
  )
  action [:start, :enable]
end
