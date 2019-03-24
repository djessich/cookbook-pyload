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

# Include recipe for install method
include_recipe "pyload::install_#{node['pyload']['install_method']}"

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

# Create symbolic links for Pyload executables to /usr/bin directory
%w(pyLoadCli pyLoadCore pyLoadGui).each do |bin|
  link "/usr/bin/#{bin}" do
    to "#{node['pyload']['install_dir']}/#{bin}.py"
  end
end

# Create symbolic link for utils.py unless it does not exist
link "#{node['pyload']['install_dir']}/module/utils.py" do
  to "#{node['pyload']['install_dir']}/module/Utils.py"
  not_if { ::File.exist?("#{node['pyload']['install_dir']}/module/utils.py") }
end
