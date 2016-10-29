#
# Cookbook Name:: pyload
# Recipe:: install
#
# Copyright 2016, Gridtec
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

directory node['pyload']['install_dir'] do
  user node['pyload']['user']
  group node['pyload']['group']
  mode node['pyload']['dir_mode']
  recursive true
end

directory node['pyload']['config_dir'] do
  user node['pyload']['user']
  group node['pyload']['group']
  mode node['pyload']['dir_mode']
  recursive true
end

directory node['pyload']['download_dir'] do
  user node['pyload']['user']
  group node['pyload']['group']
  mode node['pyload']['dir_mode']
  recursive true
end

directory node['pyload']['pid_dir'] do
  user node['pyload']['user']
  group node['pyload']['group']
  mode node['pyload']['dir_mode']
  recursive true
end

directory node['pyload']['log_dir'] do
  user node['pyload']['user']
  group node['pyload']['group']
  mode node['pyload']['dir_mode']
  recursive true
end

execute 'system_check_pyload' do
  command 'echo \n | python systemCheck.py'
  cwd node['pyload']['install_dir']
  action :nothing
  # not_if node['platform'].eql?('rhel') && node['platform_version'].to_f == 7
  only_if { ::File.exist?("#{node['pyload']['install_dir']}/systemCheck.py") }
  not_if { node['platform_family'].eql?('freebsd') }
end

version = if node['pyload']['version'] =~ /^[0-9\.]*$/
            "v#{node['pyload']['version']}"
          else
            node['pyload']['version']
          end

git node['pyload']['install_dir'] do
  repository 'https://github.com/pyload/pyload.git'
  revision version
  checkout_branch version
  enable_checkout false
  user node['pyload']['user']
  group node['pyload']['group']
  action :sync
  notifies :run, 'execute[system_check_pyload]', :immediately
  notifies :restart, 'service[pyload]', :dealayed
end

# this fix only applies to suse platform family as Pyload fails to start due to
# an error of file function we will comment out the following line
# 'translation.func_globals['find'] = find' of file <pyload_install_dir>/module/common/pylgettext.py
execute 'opensuse_fix' do
  command "sed -i s/translation.func_globals/#translation.func_globals/g #{node['pyload']['install_dir']}/module/common/pylgettext.py"
  only_if "grep -q ^translation.func_globals.* #{node['pyload']['install_dir']}/module/common/pylgettext.py"
end if node['platform_family'].eql?('suse') && node['pyload']['use_fix']

%w(pyLoadCli pyLoadCore pyLoadGui).each do |bin|
  link "/usr/bin/#{bin}" do
    to "#{node['pyload']['install_dir']}/#{bin}.py"
  end
end
