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

case node['platform_family']
when 'debian'
  # Download Pyload distribution
  remote_file "#{Chef::Config[:file_cache_path]}/pyload_#{node['pyload']['version']}_all.deb" do
    source "https://github.com/pyload/pyload/releases/download/v#{node['pyload']['version']}/pyload_#{node['pyload']['version']}_all.deb"
    owner 'root'
    group root_group
    mode '0644'
  end

  # Installs and configures Pyload distribution
  dpkg_package 'pyload' do
    source "#{Chef::Config[:file_cache_path]}/pyload_#{node['pyload']['version']}_all.deb"
    notifies :restart, 'pyload_service[pyload]', :delayed
  end
else
  raise 'Install method package is not supported for your platform'
end
