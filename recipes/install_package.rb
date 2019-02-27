#
# Copyright 2019 Dominik Jessich
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

# Raise error on platform family other than debian
raise 'Install method is only supported for Debian platform family' unless node['platform_family'].eql?('debian')

# Download Pyload distribution
remote_file "#{Chef::Config[:file_cache_path]}/pyload_#{node['pyload']['version']}_all.deb" do
  source "https://github.com/pyload/pyload/releases/download/v#{node['pyload']['version']}/pyload_#{node['pyload']['version']}_all.deb"
  owner 'root'
  group 'root'
  mode '0644'
end

# Installs and configures Pyload distribution
dpkg_package 'pyload' do
  source "#{Chef::Config[:file_cache_path]}/pyload_#{node['pyload']['version']}_all.deb"
  notifies :run, 'execute[pyload system check]', :immediately
  notifies :restart, 'pyload_service[pyload]', :delayed
end

# Define command to execute a system check for Pyload
execute 'pyload system check' do
  command "echo '\n' | #{python_bin} #{node['pyload']['install_dir']}/systemCheck.py"
  action :nothing
  only_if { ::File.exist?("#{node['pyload']['install_dir']}/systemCheck.py") }
  # not_if { node['platform_family'].eql?('freebsd') }
end

# Create logging directory
directory node['pyload']['log_dir'] do
  owner node['pyload']['user']
  group node['pyload']['group']
  mode '0755'
  recursive true
end

# Create pid directory
directory node['pyload']['pid_dir'] do
  owner node['pyload']['user']
  group node['pyload']['group']
  mode '0755'
  recursive true
end
