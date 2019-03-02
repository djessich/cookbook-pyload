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

# Include ark cookbook
include_recipe 'ark'

# Create install directory
directory ::File.dirname(node['pyload']['install_dir']) do
  owner 'root'
  group root_group
  mode '0755'
  recursive true
end

# Installs and configures Pyload distribution as specified in attributes;
# thereby this resource creates a distribution directory in the configured
# install directory and symlinks it to a directory with name pyload
ark 'pyload' do
  version node['pyload']['version']
  url "https://github.com/pyload/pyload/archive/v#{node['pyload']['version']}.tar.gz"
  # checksum download_checksum
  prefix_root ::File.dirname(node['pyload']['install_dir'])
  prefix_home ::File.dirname(node['pyload']['install_dir'])
  owner node['pyload']['user']
  group node['pyload']['group']
  mode '0755'
  notifies :run, 'execute[pyload system check]', :immediately
  notifies :restart, 'pyload_service[pyload]', :delayed
end
