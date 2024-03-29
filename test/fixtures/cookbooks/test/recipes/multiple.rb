#
# Cookbook:: test
# Recipe:: multiple
#
# Copyright:: 2022, Dominik Jessich
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

pyload_install 'instance1' do
  notifies :restart, 'pyload_service[instance1]', :delayed
end

pyload_config 'instance1' do
  port 8001
  notifies :restart, 'pyload_service[instance1]', :delayed
end

pyload_service 'instance1' do
  env_vars(
    'LANG' => locale
  )
  action [:start, :enable]
end

pyload_install 'instance2' do
  notifies :restart, 'pyload_service[instance2]', :delayed
end

pyload_config 'instance2' do
  port 8002
  notifies :restart, 'pyload_service[instance2]', :delayed
end

pyload_service 'instance2' do
  env_vars(
    'LANG' => locale
  )
  action [:start, :enable]
end
