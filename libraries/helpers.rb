#
# Cookbook:: pyload
# Library:: helpers
#
# Copyright:: 2021, Dominik Jessich
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

module PyloadCookbook
  module Helpers
    def default_instance?(instance_name)
      %w(default pyload).include?(instance_name)
    end

    # Returns the default pyload version.
    def default_pyload_version
      '0.4.20'
    end

    # Returns the default pyload install method.
    def default_pyload_install_method
      'source'
    end

    # Returns the absolute path to default pyload install directory.
    def default_pyload_install_dir(instance_name)
      default_instance?(instance_name) ? '/opt/pyload' : "/opt/pyload_#{instance_name}"
    end

    # Returns the absolute path to default pyload data directory.
    def default_pyload_data_dir(instance_name)
      default_instance?(instance_name) ? '/var/lib/pyload' : "/var/lib/pyload_#{instance_name}"
    end

    # Returns the absolute path to default pyload log directory.
    def default_pyload_log_dir(instance_name)
      default_instance?(instance_name) ? '/var/log/pyload' : "/var/log/pyload_#{instance_name}"
    end

    # Returns the absolute path to default pyload storage directory.
    def default_pyload_download_dir(instance_name)
      default_instance?(instance_name) ? '/tmp/downloads' : "/tmp/downloads_#{instance_name}"
    end

    # Returns the absolute path to default pyload tmp directory.
    def default_pyload_tmp_dir(instance_name)
      default_instance?(instance_name) ? '/tmp/pyload' : "/tmp/pyload_#{instance_name}"
    end

    # Returns the default pyload user name.
    def default_pyload_user(instance_name)
      default_instance?(instance_name) ? 'pyload' : "pyload_#{instance_name}"
    end

    # Returns the default pyload group name.
    def default_pyload_group(instance_name)
      default_instance?(instance_name) ? 'pyload' : "pyload_#{instance_name}"
    end

    # Returns the absolute path to default pyload distribution path for given
    # pyload version.
    def default_pyload_source_path(version)
      "#{Chef::Config['file_cache_path']}/pyload-#{version}"
    end

    # Returns the default download URL to pyload distribution for given pyload
    # version.
    def default_pyload_source_url(version)
      urls = {
        '0.4.20' => 'https://github.com/pyload/pyload/archive/refs/tags/v0.4.20.tar.gz',
        '0.5.0b1.dev5' => 'https://files.pythonhosted.org/packages/e5/7c/d46c122fa52b0394b789aef21085459dec2a0b9c97506dec6802f765bd2d/pyload-ng-0.5.0b1.dev5.tar.gz',
      }
      urls[version]
    end

    # Returns the default checksum of pyload distribution for given pyload
    # version.
    def default_pyload_source_checksum(version)
      checksums = {
        '0.4.20' => '438f9a2fc8ecb13b75f55b00192a2192c96a0a08ec1ae842cea17c7c49aab500',
        '0.5.0b1.dev5' => '131e53751e2aa3b4544c409f19bb4bd28976dfb813b3a59aa47caea203e24799',
      }
      checksums[version]
    end

    # Returns the default template source of pyload configuration for given
    # pyload version.
    def default_pyload_config_source(version)
      pyload_next?(version) ? 'pyload.cfg.erb' : 'pyload.conf.erb'
    end

    # Returns the default value of config option theme for given pyload version.
    def default_pyload_config_value_theme(version)
      pyload_next?(version) ? 'Default' : 'classic'
    end

    # Returns the default pyload service name.
    def default_pyload_service_name(instance_name)
      default_instance?(instance_name) ? 'pyload' : "pyload_#{instance_name}"
    end

    # Returns the default pyload service kill signal.
    def default_pyload_kill_signal
      'SIGINT'
    end

    # Returns the default pyload service restart policy.
    def default_pyload_restart_policy
      'always'
    end

    # Checks if given version refers to pyload next (pyload-ng).
    def pyload_next?(version)
      version >= '0.5.0'
    end

    # Returns required python packages regarding the specified pyload version
    # and the nodes platform.
    def python_packages(version)
      pyload_next?(version) ? python3_packages : python2_packages
    end

    # Returns Python 2 packages regarding the nodes platform.
    def python2_packages
      case node['platform_family']
      when 'debian'
        %w(python python-dev virtualenv)
      when 'fedora'
        %w(python2 python2-devel virtualenv)
      when 'rhel'
        if node['platform_version'].to_i < 8
          %w(python python-devel python-virtualenv)
        else
          %w(python2 python2-devel virtualenv)
        end
      when 'suse'
        %w(python python-devel python2-virtualenv)
      else
        raise "Unsupported platform family #{node['platform_family']}. Is it supported by this cookbook?"
      end
    end

    # Returns Python 3 packages regarding the nodes platform.
    def python3_packages
      # Some Ubuntu versions lack support of Python 3 in their minimal install,
      # so set package names from deadsnakes Ubuntu PPA
      return %w(python3.6 python3.6-dev python3.6-venv) if platform?('ubuntu') && node['platform_version'] <= '16.04'

      # On Oracle 8+ the Python 3 package configured below, cannot be correctly
      # determined by system package manager, so specify direct Python 3 packages
      return %w(python36 python36-devel) if platform?('oracle') && node['platform_version'].to_i >= 8

      case node['platform_family']
      when 'debian'
        %w(python3 python3-dev python3-venv)
      when 'rhel', 'fedora', 'suse'
        %w(python3 python3-devel)
      else
        raise "Unsupported platform family #{node['platform_family']}. Is it supported by this cookbook?"
      end
    end

    # Returns the Python virtual environment command regarding the specified
    # pyload version and the nodes platform.
    def python_virtualenv_command(version, path)
      pyload_next?(version) ? python3_virtualenv_command(path) : python2_virtualenv_command(path)
    end

    # Returns the Python 2 virtual environment command regarding the nodes
    # platform.
    def python2_virtualenv_command(path)
      "virtualenv -p /usr/bin/python2 #{path}"
    end

    # Returns the Python 3 virtual environment command regarding the nodes
    # platform.
    def python3_virtualenv_command(path)
      # Some Ubuntu versions lack support of Python 3 in their minimal install,
      # so refer to binary from deadsnakes Ubuntu PPA, otherwise use a default
      cmd = if platform?('ubuntu') && node['platform_version'] <= '16.04'
              '/usr/bin/python3.6'
            else
              '/usr/bin/python3'
            end
      cmd << " -m venv #{path}"
      cmd
    end

    # Returns the PIP upgrade command for a virtual environment regarding the
    # specified pyload version and the nodes platform.
    def pip_virtualenv_upgrade_command(version, path)
      pyload_next?(version) ? pip3_virtualenv_upgrade_command(path) : pip2_virtualenv_upgrade_command(path)
    end

    # Returns the PIP 2 upgrade command for a virtual environment regarding the
    # nodes platform.
    def pip2_virtualenv_upgrade_command(path)
      "#{path}/bin/pip install --disable-pip-version-check --no-cache-dir --upgrade pip setuptools==44.1.1 wheel"
    end

    # Returns the PIP 3 upgrade command for a virtual environment regarding the
    # nodes platform.
    def pip3_virtualenv_upgrade_command(path)
      "#{path}/bin/pip install --disable-pip-version-check --no-cache-dir --upgrade pip setuptools wheel"
    end

    # Returns dependency packages of pyload regarding nodes platform family.
    def dependency_packages
      case node['platform_family']
      when 'debian'
        %w(curl libcurl4-openssl-dev openssl libssl-dev sqlite3 tesseract-ocr tesseract-ocr-eng)
      when 'rhel', 'fedora'
        %w(curl libcurl-devel openssl openssl-devel sqlite tesseract)
      when 'suse'
        %w(curl libcurl-devel openssl libopenssl-devel sqlite3 tesseract-ocr)
      else
        raise "Unsupported platform family #{node['platform_family']}. Is it supported by this cookbook?"
      end
    end

    # Return resource with type :pyload_install matching given resource.
    def find_pyload_install_resource!(resource)
      install_pip_match = begin
                            find_pyload_resource!(run_context, :pyload_install_pip, resource)
                          rescue
                            nil
                          end
      return install_pip_match if install_pip_match

      install_source_match = begin
                               find_pyload_resource!(run_context, :pyload_install_source, resource)
                             rescue
                               nil
                             end
      return install_source_match if install_source_match

      find_pyload_resource!(run_context, :pyload_install, resource)
    end

    # Returns the ssl library backend for pycurl pip package.
    def pycurl_ssl_library_backend
      return 'nss' if platform_family?('rhel') && node['platform_version'].to_i < 8
      'openssl'
    end

    # Return resource with type :pyload_config matching given resource.
    def find_pyload_config_resource!(resource)
      find_pyload_resource!(run_context, :pyload_config, resource)
    end

    # Return resource with type :pyload_service matching given resource.
    def find_pyload_service_resource!(resource)
      find_pyload_resource!(run_context, :pyload_service, resource)
    end

    # Find a resource matching given resource of given resource type in given
    # run context. The found resource matching given resource is returned or an
    # or an exception is raised if none was found.
    #
    # The following match routines are implemented:
    # 1. resource name from given resource
    # 2. instance_name property from given resource
    # 3. resource name set to either 'default' or 'pyload'
    def find_pyload_resource!(run_context, resource_type, resource)
      # Try to find a matching resource by name
      name_match = find_exact_resource(run_context, resource_type, resource.name)
      return name_match if name_match

      # Try to find a matching resource by instance name
      instance_match = find_instance_name_resource(run_context, resource_type, resource.instance_name)
      return instance_match if instance_match

      # Try to find a matching resource by using defaults for resource name
      default_name_match = find_exact_resource(run_context, resource_type, 'default')
      pyload_name_match = find_exact_resource(run_context, resource_type, 'pyload')
      return default_name_match if default_name_match && !pyload_name_match
      return pyload_name_match if pyload_name_match && !default_name_match

      # Try to find a matching resource by using defaults for instance name
      default_instance_name_match = find_instance_name_resource(run_context, resource_type, 'default')
      pyload_instance_name_match = find_instance_name_resource(run_context, resource_type, 'pyload')
      return default_instance_name_match if default_instance_name_match && !pyload_instance_name_match
      return pyload_instance_name_match if pyload_instance_name_match && !default_instance_name_match

      # Raise error to indicate a missing match for given arguments
      raise "Could not find one matching resource of type #{resource_type}."
    end

    # Find a resource with given resource type and resource name in given run
    # context. The found resource is returned or nil if none was found. Raises
    # an exception if multiple resources were found matching the given arguments.
    def find_exact_resource(run_context, resource_type, resource_name)
      result = begin
                 run_context.resource_collection.find(resource_type => resource_name)
               rescue
                 nil
               end
      raise "Multiple resources of type #{resource_type} with resource name #{resource_name} were found." if result && result.is_a?(Array)
      result
    end

    # Find a resource with given resource type and instance name in given run
    # context. The found resource is returned or nil if none was found. Raises
    # an exception if multiple resources were found matching the given arguments.
    def find_instance_name_resource(run_context, resource_type, instance_name)
      results = run_context.resource_collection.select { |r| r.resource_name == resource_type && r.instance_name == instance_name }
      raise "Multiple resources of type #{resource_type} with instance name #{instance_name} were found." if !results.empty? && results.length > 1
      results.empty? ? nil : results.first
    end
  end
end
