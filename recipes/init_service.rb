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

dist_dir, conf_dir = value_for_platform_family(
  debian: %w(debian default),
  fedora: %w(rhel sysconfig),
  rhel:   %w(rhel sysconfig),
  suse:   %w(suse sysconfig)
)

template '/etc/init.d/pyload' do
  source "#{dist_dir}/init.d/pyload.erb"
  mode '0755'
  notifies :restart, 'service[pyload]', :delayed
end

template "/etc/#{conf_dir}/pyload" do
  source "#{dist_dir}/#{conf_dir}/pyload.erb"
  mode '0644'
  notifies :restart, 'service[pyload]', :delayed
end

service 'pyload' do
  supports status: true, restart: true
  action [:enable, :start]
end
