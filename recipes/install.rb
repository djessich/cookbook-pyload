#
# Cookbook Name:: pyload
# Recipe:: default
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

# TODO: Execute system check script to ensure that everything is correctly setup

directory node['pyload']['pid_dir'] do
  user node['pyload']['user']
  group node['pyload']['group']
  mode node['pyload']['dir_mode']
  recursive true
end

directory node['pyload']['install_dir'] do
  user node['pyload']['user']
  group node['pyload']['group']
  mode node['pyload']['dir_mode']
  recursive true
end

execute 'system_check_pyload' do
  command 'python systemCheck.py'
  cwd node['pyload']['install_dir']
  action :nothing
end

git node['pyload']['install_dir'] do
  repository 'https://github.com/pyload/pyload.git'
  revision 'stable'
  #  checkout_branch 'stable'
  user node['pyload']['user']
  group node['pyload']['group']
  action :sync
  notifies :run, 'execute[system_check_pyload]', :immediately
end

%w(pyLoadCli pyLoadCore pyLoadGui).each do |bin|
  link "/usr/bin/#{bin}" do
    to "#{node['pyload']['install_dir']}/#{bin}.py"
  end
end
