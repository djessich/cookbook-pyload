#
# Cookbook:: pyload
# Resource:: install_source
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
property :version, String, default: '0.4.20'
property :install_dir, String, default: lazy { default_pyload_install_dir(instance_name) }
property :data_dir, String, default: lazy { default_pyload_data_dir(instance_name) }
property :log_dir, String, default: lazy { default_pyload_log_dir(instance_name) }
property :download_dir, String, default: lazy { default_pyload_download_dir(instance_name) }
property :tmp_dir, String, default: lazy { default_pyload_tmp_dir(instance_name) }
property :user, String, default: lazy { default_pyload_user(instance_name) }
property :group, String, default: lazy { default_pyload_group(instance_name) }
property :source_path, String, default: lazy { default_pyload_source_path(version) }, desired_state: false
property :source_url, String, default: lazy { default_pyload_source_url(version) }, desired_state: false
property :source_checksum, String, regex: /^[a-zA-Z0-9]{64}$/, default: lazy { default_pyload_source_checksum(version) }, desired_state: false
property :create_user, [true, false], default: true, desired_state: false
property :create_group, [true, false], default: true, desired_state: false
property :create_download_dir, [true, false], default: true, desired_state: false
property :create_symlink, [true, false], default: true, desired_state: false

action :install do
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

  # Some RHEL systems lack tar in their minimal install
  package %w(tar gzip)

  build_essential 'install build packages'

  package 'install python packages' do
    package_name python2_packages
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
    command python2_virtualenv_command(full_install_path)
    creates full_install_path
    notifies :run, 'execute[upgrade pip packages to latest version in virtual environment]', :immediately
  end

  # On Ubuntu 16.04 the installed version of setuptools is 45.0.0 which does not
  # support Python 2, so pin setuptools to version 44.1.1 which does support it
  execute 'upgrade pip packages to latest version in virtual environment' do
    command "#{full_install_path}/bin/pip install --disable-pip-version-check --no-cache-dir --upgrade pip setuptools==44.1.1 wheel"
    action :nothing
  end

  %w(beaker beautifulsoup4 feedparser flup html5lib jinja2 js2py pillow pycrypto pycurl pyopenssl pytesseract thrift).each do |pip_pkg|
    execute "install pip package #{pip_pkg} in virtual environment" do
      command "#{full_install_path}/bin/pip install --disable-pip-version-check --no-cache-dir #{pip_pkg}"
      environment(
        'PYCURL_SSL_LIBRARY' => pycurl_ssl_library_backend
      )
      not_if "#{full_install_path}/bin/pip show #{pip_pkg}"
    end
  end

  directory 'create distribution directory in virtual environment' do
    path "#{full_install_path}/dist"
    owner new_resource.user
    group new_resource.group
    mode '0755'
    recursive true
  end

  remote_file 'download pyload distribution source' do
    path new_resource.source_path
    source new_resource.source_url
    checksum new_resource.source_checksum
    owner 'root'
    group node['root_group']
    mode '0644'
  end

  execute 'extract pyload distribution source to virtual environment' do
    command extract_command
    creates "#{full_install_path}/dist/LICENSE.MD"
  end

  # Ensure the instance user owns the distribution directory
  execute 'ensure permissions of distribution directory contents in virtual environment' do
    command "chown -R #{new_resource.user}:#{new_resource.group} #{full_install_path}/dist"
    not_if { ::Etc.getpwuid(::File.stat("#{full_install_path}/dist/LICENSE.MD").uid).name == new_resource.user }
  end

  %w(pyLoadCli pyLoadCore pyLoadGui).each do |bin|
    link "#{full_install_path}/bin/#{bin}" do
      to "#{full_install_path}/dist/#{bin}.py"
    end
  end

  %W(
    #{new_resource.data_dir}
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

  # Returns the command to extract pyload distribution to full install directory
  # for specified pyload version. Thereby the first component will# be stripped.
  def extract_command
    "tar -xzf #{new_resource.source_path} -C #{full_install_path}/dist --strip-components=1"
  end
end
