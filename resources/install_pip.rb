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
property :version, String, default: '0.5.0b1.dev5'
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
  raise 'Install method pip is only supported for version >= 0.5.0.' unless pyload_next?(new_resource.version)

  if platform_family?('rhel')
    # Setup EPEL repository on RHEL to install required packages
    include_recipe 'yum-epel'

    # Setup tesseract repository unless leptonica package is available
    yum_repository 'tesseract' do
      description "Tesseract Packages for #{node['platform_version'].to_i} - $basearch"
      baseurl "https://download.opensuse.org/repositories/home:/Alexander_Pozdnyakov/CentOS_#{node['platform_version'].to_i}/"
      enabled true
      make_cache true
      gpgcheck true
      gpgkey "https://download.opensuse.org/repositories/home:/Alexander_Pozdnyakov/CentOS_#{node['platform_version'].to_i}/repodata/repomd.xml.key"
      not_if 'yum whatprovides leptonica'
    end
  end

  # Some Ubuntu versions lack support of Python 3.6+ in their minimal install,
  # so add deadsnakes Ubuntu PPA
  if platform?('ubuntu') && node['platform_version'] <= '16.04'
    apt_repository 'deadsnakes-ubuntu-ppa' do
      uri 'ppa:deadsnakes/ppa'
    end
  end

  build_essential 'install build packages'

  package 'install python packages' do
    package_name python_packages(new_resource.version)
    options '--enablerepo=ol7_optional_latest' if platform?('oracle') && node['platform_version'].to_i == 7
  end

  package 'install dependency packages' do
    package_name dependency_packages
  end

  group new_resource.group do
    append true
    system true
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
    command python_virtualenv_command(new_resource.version, full_install_path)
    creates full_install_path
    notifies :run, 'execute[upgrade pip packages to latest version in virtual environment]', :immediately
  end

  execute 'upgrade pip packages to latest version in virtual environment' do
    command pip_virtualenv_upgrade_command(new_resource.version, full_install_path)
    action :nothing
  end

  execute 'install pyload using pip in virtual environment' do
    command "#{full_install_path}/bin/pip install --disable-pip-version-check --no-cache-dir pyload-ng[all]==#{new_resource.version}"
    environment(
      'PYCURL_SSL_LIBRARY' => pycurl_ssl_library_backend
    )
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
end
