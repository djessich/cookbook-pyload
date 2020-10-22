#
# Cookbook:: pyload
# Resource:: install_pip
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

property :instance_name, String, name_property: true
property :version, String, default: '0.5.0a9.dev655'
property :install_dir, String, default: lazy { default_pyload_install_dir(instance_name) }
property :data_dir, String, default: lazy { default_pyload_data_dir(instance_name) }
property :log_dir, String, default: lazy { default_pyload_log_dir(instance_name) }
property :download_dir, String, default: lazy { default_pyload_download_dir(instance_name) }
property :tmp_dir, String, default: lazy { default_pyload_tmp_dir(instance_name) }
property :user, String, default: lazy { default_pyload_user(instance_name) }
property :group, String, default: lazy { default_pyload_group(instance_name) }
property :create_user, [true, false], default: true, desired_state: false
property :create_group, [true, false], default: true, desired_state: false
property :create_download_dir, [true, false], default: true, desired_state: false
property :create_symlink, [true, false], default: true, desired_state: false

action :install do
  # Setup EPEL repository on RHEL to install required packages
  include_recipe 'yum-epel' if rhel?

  build_essential 'install build packages'

  package 'install python packages' do
    package_name python3_packages
  end

  package 'install dependency packages' do
    package_name dependency_packages
  end

  group new_resource.group do
    system true
    append true
    only_if { new_resource.create_group }
  end

  user new_resource.user do
    gid new_resource.group
    home new_resource.data_dir
    shell '/bin/false'
    system true
    only_if { new_resource.create_user }
  end

  execute 'create virtual environment' do
    command virtualenv_command
    creates full_install_path
    notifies :run, 'execute[upgrade pip to latest version]', :immediately
  end

  execute 'upgrade pip to latest version' do
    command "#{full_install_path}/bin/pip install --upgrade pip"
    action :nothing
  end

  execute 'install pyload using pip' do
    command "#{full_install_path}/bin/pip install pyload-ng[all]==#{new_resource.version}"
    creates "#{full_install_path}/bin/pyload"
  end

  %W(
    #{new_resource.tmp_dir}
    #{new_resource.data_dir}
    #{new_resource.data_dir}/data
    #{new_resource.data_dir}/plugins
    #{new_resource.data_dir}/scripts
    #{new_resource.data_dir}/settings
    #{new_resource.log_dir}
  ).each do |dir|
    directory dir do
      owner new_resource.user
      group new_resource.group
      mode '0755'
      recursive true
    end
  end

  directory new_resource.download_dir do
    owner new_resource.user
    group new_resource.group
    mode '0755'
    recursive true
    only_if { new_resource.create_download_dir }
  end

  # Create a link that points to the latest version of pyload
  link new_resource.install_dir do
    to full_install_path
    only_if { new_resource.create_symlink }
  end
end

action_class do
  # Returns dependency packages of pyload regarding nodes platform family.
  def dependency_packages
    case node['platform_family']
    when 'debian'
      %w(curl libcurl4-openssl-dev libssl-dev)
    when 'rhel', 'fedora'
      %w(curl libcurl-devel openssl-devel)
    else
      raise "Unsupported platform family #{node['platform_family']}. Is it supported by this cookbook?"
    end
  end

  # Returns the absolute path to full install directory for specified pyload
  # version.
  def full_install_path
    dir = if default_instance?(new_resource.instance_name)
            "pyload-#{new_resource.version}"
          else
            "pyload_#{new_resource.instance_name}-#{new_resource.version}"
          end
    "#{::File.dirname(new_resource.install_dir)}/#{dir}"
  end

  # Returns the command to create a python virtual environment in full install
  # directory for specified pyload version.
  def virtualenv_command
    if pyload_next?(new_resource.version)
      "/usr/bin/python3 -m venv #{full_install_path}"
    else
      "virtualenv #{full_install_path}"
    end
  end
end
