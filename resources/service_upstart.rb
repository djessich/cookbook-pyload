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

provides :pyload_service_upstart

provides :pyload_service, platform_family: 'debian' do |node|
  Chef::Platform::ServiceHelpers.service_resource_providers.include?(:upstart) &&
  !Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
end

property :service_name, String, name_property: true
property :install_dir, String, default: lazy { node['pyload']['install_dir'] }
property :conf_dir, String, default: lazy { node['pyload']['conf_dir'] }
property :pid_dir, String, default: lazy { node['pyload']['pid_dir'] }
property :user, String, default: lazy { node['pyload']['user'] }
property :group, String, default: lazy { node['pyload']['group'] }

action :start do
  create_init

  service new_resource.service_name do
    provider Chef::Provider::Service::Upstart
    supports status: true, restart: true
    action :start
  end
end

action :stop do
  service new_resource.service_name do
    provider Chef::Provider::Service::Upstart
    supports status: true, restart: true
    action :stop
    only_if { ::File.exist?("/etc/init/#{new_resource.service_name}") }
  end
end

action :enable do
  create_init

  service new_resource.service_name do
    provider Chef::Provider::Service::Upstart
    supports status: true, restart: true
    action :enable
  end
end

action :disable do
  service new_resource.service_name do
    provider Chef::Provider::Service::Upstart
    supports status: true, restart: true
    action :disable
    only_if { ::File.exist?("/etc/init/#{new_resource.service_name}") }
  end
end

action :restart do
  service new_resource.service_name do
    provider Chef::Provider::Service::Upstart
    supports status: true, restart: true
    action :restart
  end
end

action_class do
  # Creates the configuration for the init system.
  def create_init
    template "/etc/init/#{new_resource.service_name}.conf" do
      source 'debian/init/pyload.conf.erb'
      owner 'root'
      group 'root'
      mode '0644'
      variables(
        install_dir: new_resource.install_dir,
        conf_dir: new_resource.conf_dir,
        pid_dir: new_resource.pid_dir,
        user: new_resource.user,
        group: new_resource.group
      )
      notifies :run, 'execute[initctl reload-configuration]', :immediate
      notifies :restart, "service[#{new_resource.service_name}]", :delayed
    end

    execute 'initctl reload-configuration' do
      action :nothing
    end
  end
end
