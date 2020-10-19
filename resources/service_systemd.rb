#
# Cookbook:: pyload
# Resource:: service_systemd
#
# Copyright:: 2020, Dominik Jessich
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

include PyloadCookbook::Helpers

provides :pyload_service_systemd

provides :pyload_service, os: 'linux' do
  Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
end

property :instance_name, String, name_property: true
property :version, [String, Integer], default: lazy { default_pyload_version }
property :service_name, String, default: lazy { default_pyload_service_name }
property :install_dir, String, default: lazy { default_pyload_install_dir }
property :data_dir, String, default: lazy { default_pyload_data_dir }
property :download_dir, String, default: lazy { default_pyload_download_dir }
property :tmp_dir, String, default: lazy { default_pyload_tmp_dir }
property :user, String, default: lazy { default_pyload_user }
property :group, String, default: lazy { default_pyload_group }

action :start do
  action_create

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
  action_create

  service new_resource.service_name do
    provider Chef::Provider::Service::Systemd
    supports status: true, restart: true
    action :enable
    only_if { ::File.exist?("/etc/systemd/system/#{new_resource.service_name}.service") }
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
    only_if { ::File.exist?("/etc/systemd/system/#{new_resource.service_name}.service") }
  end
end

action :create do
  systemd_unit "#{new_resource.service_name}.service" do
    content(
      'Unit' => {
        'Description' => 'Pyload - The free and open-source Download Manager written in pure Python',
        'After' => 'local-fs.target remote-fs.target network.target network-online.target',
      },
      'Service' => {
        'Type' => 'simple',
        'ExecStart' => start_command,
        'User' => new_resource.user,
        'Group' => new_resource.group,
        'KillSignal' => 'SIGQINT',
        'Restart' => 'always',
      },
      'Install' => {
        'WantedBy' => 'multi-user.target',
      }
    )
    action :create
  end
end

action_class do
  # Returns the command to start pyload for specified pyload version.
  def start_command
    cmd = "#{new_resource.install_dir}/bin/python "
    if pyload_next?(new_resource.version)
      cmd << "#{new_resource.install_dir}/bin/pyload"
      cmd << " --userdir #{new_resource.data_dir}"
      cmd << " --storagedir #{new_resource.download_dir}"
      cmd << " --tempdir #{new_resource.tmp_dir}"
    else
      cmd << "#{new_resource.install_dir}/bin/pyLoadCore"
      cmd << " --configdir=#{new_resource.data_dir}"
    end
  end
end
