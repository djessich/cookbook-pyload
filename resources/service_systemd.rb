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

provides :pyload_service_systemd

provides :pyload_service, os: 'linux' do
  Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
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
    provider Chef::Provider::Service::Systemd
    supports status: true, restart: true
    action :start
  end
end

action :stop do
  service new_resource.service_name do
    provider Chef::Provider::Service::Systemd
    supports status: true, restart: true
    action :stop
    only_if { ::File.exist?("/etc/systemd/system/#{new_resource.service_name}.service") }
  end
end

action :enable do
  create_init

  service new_resource.service_name do
    provider Chef::Provider::Service::Systemd
    supports status: true, restart: true
    action :enable
  end
end

action :disable do
  service new_resource.service_name do
    provider Chef::Provider::Service::Systemd
    supports status: true, restart: true
    action :disable
    only_if { ::File.exist?("/etc/systemd/system/#{new_resource.service_name}.service") }
  end
end

action :restart do
  service new_resource.service_name do
    provider Chef::Provider::Service::Systemd
    supports status: true, restart: true
    action :restart
  end
end

action_class do
  # Creates the configuration for the init system.
  def create_init
    template "/etc/systemd/system/#{new_resource.service_name}.service" do
      source 'systemd_unit.erb'
      owner 'root'
      group root_group
      mode '0644'
      variables(
        install_dir: new_resource.install_dir,
        conf_dir: new_resource.conf_dir,
        pid_dir: new_resource.pid_dir,
        user: new_resource.user,
        group: new_resource.group
      )
      notifies :run, 'execute[Load systemd unit file]', :immediately
      notifies :restart, "service[#{new_resource.service_name}]", :delayed
      notifies :run, 'bash[journalctl]', :delayed
    end

    execute 'Load systemd unit file' do
      command 'systemctl daemon-reload'
      action :nothing
    end

    bash 'journalctl' do
      code <<-EOH
        journalctl -xe &> /tmp/journalctl
      EOH
      action :nothing
      notifies :run, 'ruby_block[print results]', :delayed
    end

    ruby_block "print results" do
      block do
        print "\n"
        ::File.open('/tmp/journalctl', 'r') do |f|
          f.each_line do |line|
            print line
          end
        end
      end
      action :nothing
      only_if { ::File.exists?('/tmp/journalctl') }
    end
  end
end
