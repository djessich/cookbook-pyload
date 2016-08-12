#
# Cookbook Name:: pyload
# Recipe:: init_service
#
# Copyright 2016, Dominik Jessich
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

template '/etc/init.d/pyload' do
  source 'init_service.erb'
  user 'root'
  group 'root'
  mode '0755'
  variables(
    install_dir: node['pyload']['install_dir'],
    config_dir: node['pyload']['config_dir'],
    user: node['pyload']['user'],
    group: node['pyload']['group'],
    pid_file: "#{node['pyload']['pid_dir']}/pyload.pid"
  )
  notifies :restart, 'service[pyload]', :delayed
end

service 'pyload' do
  supports status: true, restart: true
  action [:enable, :start]
end
