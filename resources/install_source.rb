#
# Cookbook:: pyload
# Resource:: install_source
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

unified_mode true

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
  # Setup EPEL repository on RHEL to install required packages
  include_recipe 'yum-epel' if platform_family?('rhel')

  # Some Ubuntu versions lack support of Python 3.6+ in their minimal install,
  # so add deadsnakes Ubuntu PPA
  if platform?('ubuntu') && node['platform_version'] <= '16.04'
    apt_repository 'deadsnakes-ubuntu-ppa' do
      uri 'ppa:deadsnakes/ppa'
    end
  end

  # Some RHEL systems lack tar in their minimal install
  package %w(tar unzip)

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

  pip_packages.each do |pip_pkg|
    execute "install pip package #{pip_pkg} in virtual environment" do
      command "#{full_install_path}/bin/pip install --disable-pip-version-check --no-cache-dir #{pip_pkg}"
      environment(
        'PYCURL_SSL_LIBRARY' => pycurl_ssl_library_backend
      )
      not_if "#{full_install_path}/bin/pip show #{pip_pkg.split('==')[0]}"
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
    creates license_path
  end

  if pyload_next?(new_resource.version)
    execute 'build locale files for pyload in virtual environment' do
      cwd "#{full_install_path}/dist"
      command "#{full_install_path}/bin/python setup.py build_locale"
      creates "#{full_install_path}/src/pyload/locale/pyload.pot"
    end

    execute 'install pyload distribution in virtual environment' do
      cwd "#{full_install_path}/dist"
      command "#{full_install_path}/bin/python setup.py install"
      creates "#{full_install_path}/bin/pyload"
    end
  else
    %w(pyLoadCli pyLoadCore pyLoadGui).each do |bin|
      link "#{full_install_path}/bin/#{bin}" do
        to "#{full_install_path}/dist/#{bin}.py"
      end
    end
  end

  execute 'ensure permissions of distribution directory contents in virtual environment' do
    command "chown -R #{new_resource.user}:#{new_resource.group} #{full_install_path}/dist"
    not_if do
      value = begin
                ::Etc.getpwuid(::File.stat(license_path).uid).name
              rescue ArgumentError
                nil
              end
      value == new_resource.user
    end
  end

  required_directories.each do |dir|
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
  # Returns the packages to be installed with Python PIP for specified pyload
  # version.
  def pip_packages
    if pyload_next?(new_resource.version)
      %w(
        Babel beautifulsoup4 bitmath cheroot colorlog cryptography filetype
        Flask Flask-Babel Flask-Caching Flask-Compress Flask-Session
        Flask-Themes2 Jinja2 Js2Py Pillow pycryptodomex pycurl pyOpenSSL pyxmpp2
        semver slixmpp Send2Trash
      )
    else
      %w(
        Beaker beautifulsoup4 feedparser flup html5lib Jinja2 Js2Py Pillow
        pycrypto pycurl pyOpenSSL pytesseract==0.3.6 thrift
      )
    end
  end

  # Returns the required directories to be created for specified pyload version.
  def required_directories
    if pyload_next?(new_resource.version)
      %W(
        #{new_resource.tmp_dir}
        #{new_resource.data_dir}
        #{new_resource.data_dir}/data
        #{new_resource.data_dir}/plugins
        #{new_resource.data_dir}/scripts
        #{new_resource.data_dir}/settings
        #{new_resource.log_dir}
      )
    else
      %W(
        #{new_resource.data_dir}
        #{new_resource.log_dir}
      )
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

  # Returns the absolute path to license file of pyload distribution for
  # specified pyload version.
  def license_path
    pyload_next?(new_resource.version) ? "#{full_install_path}/dist/LICENSE.md" : "#{full_install_path}/dist/LICENSE.MD"
  end

  # Returns the command to extract pyload distribution to full install directory.
  # The command will be specific to the distribution archive and the first
  # component will be stripped from archive.
  def extract_command
    if ::File.basename(new_resource.source_url).end_with?('zip')
      require 'tmpdir'
      tmpdir = ::Dir.mktmpdir
      "unzip -q -o #{new_resource.source_path} -d #{tmpdir} && cp -R #{tmpdir}/*/* #{full_install_path}/dist && rm -rf #{tmpdir}"
    else
      "tar -xzf #{new_resource.source_path} -C #{full_install_path}/dist --strip-components=1"
    end
  end
end
