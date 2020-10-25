#
# Cookbook:: pyload
# Resource:: install_tarball_pip
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
property :tarball_path, String, default: lazy { default_pyload_tarball_path(version) }, desired_state: false
property :tarball_url, String, default: lazy { default_pyload_tarball_url(version) }, desired_state: false
property :tarball_checksum, String, regex: /^[a-zA-Z0-9]{64}$/, default: lazy { default_pyload_tarball_checksum(version) }, desired_state: false
property :create_user, [true, false], default: true, desired_state: false
property :create_group, [true, false], default: true, desired_state: false
property :create_download_dir, [true, false], default: true, desired_state: false
property :create_symlink, [true, false], default: true, desired_state: false

action :install do
  # Setup EPEL repository on RHEL to install required packages
  include_recipe 'yum-epel' if platform_family?('rhel')

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

  execute 'upgrade pip packages to latest version in virtual environment' do
    command "#{full_install_path}/bin/pip install --disable-pip-version-check --no-cache-dir --upgrade pip setuptools wheel"
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

  directory 'create dist directory' do
    path "#{full_install_path}/dist"
    owner 'root'
    group node['root_group']
    mode '0755'
    recursive true
  end

  remote_file 'download pyload distribution tarball' do
    path new_resource.tarball_path
    source new_resource.tarball_url
    checksum new_resource.tarball_checksum
    owner 'root'
    group node['root_group']
    mode '0644'
  end

  execute 'extract pyload dist tarball to virtual environment' do
    command extract_command
    creates "#{full_install_path}/dist/LICENSE.MD"
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
  # Returns dependency packages of pyload regarding nodes platform family.
  def dependency_packages
    case node['platform_family']
    when 'debian'
      %w(tar gzip curl libcurl4-openssl-dev libssl-dev tesseract-ocr tesseract-ocr-eng)
    when 'rhel', 'fedora'
      %w(tar gzip curl libcurl-devel openssl-devel tesseract)
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

  # Returns the command to extract pyload distribution tarball to full install
  # directory for specified pyload version. Thereby the first component will
  # be stripped.
  def extract_command
    "tar -xzf #{new_resource.tarball_path} -C #{full_install_path}/dist --strip-components=1"
  end
end
