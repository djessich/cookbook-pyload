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

provides :pyload_service_bsd

provides :pyload_service, platform_family: 'bsd'

property :service_name, String, name_property: true
property :install_dir, String, default: lazy { node['pyload']['install_dir'] }
property :conf_dir, String, default: lazy { node['pyload']['conf_dir'] }
property :pid_dir, String, default: lazy { node['pyload']['pid_dir'] }
property :user, String, default: lazy { node['pyload']['user'] }
property :group, String, default: lazy { node['pyload']['group'] }

action :start do
  create_init

  service new_resource.service_name do
    supports status: true, restart: true
    action :start
  end
end

action :stop do
  service new_resource.service_name do
    supports status: true, restart: true
    action :stop
    only_if { ::File.exist?("/etc/init.d/#{new_resource.service_name}") }
  end
end

action :enable do
  create_init

  service new_resource.service_name do
    supports status: true, restart: true
    action :enable
  end
end

action :disable do
  service new_resource.service_name do
    supports status: true, restart: true
    action :disable
    only_if { ::File.exist?("/etc/init.d/#{new_resource.service_name}") }
  end
end

action :restart do
  service new_resource.service_name do
    supports status: true, restart: true
    action :restart
  end
end

action_class do
  # Creates the configuration for the init system.
  def create_init
    directory '/etc/rc.conf.d' do
      owner 'root'
      group 'wheel'
      mode '0644'
    end

    template '/etc/rc.conf.d/pyload' do
      source 'rc.conf.d/pyload.erb'
      owner 'root'
      group 'wheel'
      mode '0644'
      notifies :restart, "service[#{new_resource.service_name}]", :delayed
    end

    template '/usr/local/etc/rc.d/pyload' do
      source 'rc.d/pyload.erb'
      owner 'root'
      group 'wheel'
      mode '0755'
      variables(
        python: python_bin,
        install_dir: new_resource.install_dir,
        conf_dir: new_resource.conf_dir,
        pid_dir: new_resource.pid_dir,
        user: new_resource.user,
        group: new_resource.group
      )
      notifies :restart, "service[#{new_resource.service_name}]", :delayed
    end
  end
end