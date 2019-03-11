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

directory node['pyload']['conf_dir'] do
  user node['pyload']['user']
  group node['pyload']['group']
  mode '0755'
  recursive true
end

template "#{node['pyload']['conf_dir']}/pyload.conf" do
  source 'pyload.conf.erb'
  user node['pyload']['user']
  group node['pyload']['group']
  mode '0600'
  notifies :restart, 'pyload_service[pyload]', :delayed
end

# template "#{node['pyload']['conf_dir']}/accounts.conf" do
#   source 'accounts.conf.erb'
#   owner node['pyload']['user']
#   group node['pyload']['group']
#   mode '0600'
#   action :create_if_missing
#   not_if { node['pyload']['accounts'].empty? }
# end

directory node['pyload']['download_dir'] do
  user node['pyload']['user']
  group node['pyload']['group']
  mode '0755'
  recursive true
end
