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

# this fix only applies to suse platform family as Pyload fails to start due to
# an error of file function we will comment out the following line
# 'translation.func_globals['find'] = find' of file <pyload_install_dir>/module/common/pylgettext.py
# execute 'opensuse_fix' do
#   # command "sed -i s/translation.func_globals/#translation.func_globals/g #{node['pyload']['install_dir']}/module/common/pylgettext.py"
#   # only_if "grep -q ^translation.func_globals.* #{node['pyload']['install_dir']}/module/common/pylgettext.py"
#   command "echo \"origfind.func_globals['find'] = origfind\" >> #{node['pyload']['install_dir']}/module/common/pylgettext.py"
#   not_if "grep -q ^origfind.func_globals.* #{node['pyload']['install_dir']}/module/common/pylgettext.py"
# end if node['platform_family'].eql?('suse') && node['pyload']['use_fix']

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
