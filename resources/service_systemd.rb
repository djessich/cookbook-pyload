#
# Cookbook:: pyload
# Resource:: service_systemd
#
# Copyright:: 2022, Dominik Jessich
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

unified_mode true

property :instance_name, String, name_property: true
property :service_name, String, default: lazy { default_pyload_service_name(instance_name) }
property :env_vars, Hash, default: {}
property :kill_signal, String, default: lazy { default_pyload_kill_signal }
property :restart_policy, String, default: lazy { default_pyload_restart_policy }

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
  pyload_install_resource = find_pyload_install_resource!(new_resource)

  service_unit_content = {
    'Unit' => {
      'Description' => 'Pyload - The free and open-source Download Manager written in pure Python',
      'After' => 'local-fs.target remote-fs.target network.target network-online.target',
    },
    'Service' => {
      'Type' => 'simple',
      'ExecStart' => start_command(pyload_install_resource.version, pyload_install_resource.install_dir, pyload_install_resource.data_dir, pyload_install_resource.download_dir, pyload_install_resource.tmp_dir),
      'User' => pyload_install_resource.user,
      'Group' => pyload_install_resource.group,
      'KillSignal' => new_resource.kill_signal,
      'Restart' => new_resource.restart_policy,
    },
    'Install' => {
      'WantedBy' => 'multi-user.target',
    },
  }

  new_resource.env_vars.each do |k, v|
    service_unit_content['Service']['Environment'] = "#{k}=#{v}"
  end

  systemd_unit "#{new_resource.service_name}.service" do
    content service_unit_content
    action :create
  end
end

action_class do
  # Returns the command to start pyload for specified pyload version.
  def start_command(version, install_dir, data_dir, download_dir, tmp_dir)
    cmd = "#{install_dir}/bin/python "
    if pyload_next?(version)
      cmd << "#{install_dir}/bin/pyload"
      cmd << " --userdir #{data_dir}"
      cmd << " --storagedir #{download_dir}"
      cmd << " --tempdir #{tmp_dir}"
    else
      cmd << "#{install_dir}/bin/pyLoadCore"
      cmd << " --configdir=#{data_dir}"
    end
  end
end
