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

# Install git on the node
package 'git'

# Create install directory
directory node['pyload']['install_dir'] do
  owner 'root'
  group root_group
  mode '0755'
  recursive true
end

# Determine the correct version to checkout from attribute
version = if node['pyload']['version'] =~ /^[0-9\.]*$/
            "v#{node['pyload']['version']}"
          else
            node['pyload']['version']
          end

# Installs and configures Pyload distribution as specified in attributes;
# thereby this resource creates a distribution directory in the specified
# install directory
git node['pyload']['install_dir'] do
  repository 'https://github.com/pyload/pyload.git'
  revision version
  user 'root'
  group root_group
  action :sync
  notifies :restart, 'pyload_service[pyload]', :delayed
end
