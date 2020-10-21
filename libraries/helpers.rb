#
# Cookbook:: pyload
# Library:: helpers
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

module PyloadCookbook
  module Helpers
    # Returns the default pyload version.
    def default_pyload_version
      '0.4.20'
    end

    # Returns the default pyload install method.
    def default_pyload_install_method
      'tarball_pip'
    end

    # Returns the absolute path to default pyload install directory.
    def default_pyload_install_dir
      '/opt/pyload'
    end

    # Returns the absolute path to default pyload data directory.
    def default_pyload_data_dir
      '/var/lib/pyload'
    end

    # Returns the absolute path to default pyload log directory.
    def default_pyload_log_dir
      '/var/log/pyload'
    end

    # Returns the absolute path to default pyload storage directory.
    def default_pyload_download_dir
      '/tmp/downloads'
    end

    # Returns the absolute path to default pyload tmp directory.
    def default_pyload_tmp_dir
      '/tmp/pyload'
    end

    # Returns the default pyload user name.
    def default_pyload_user
      'pyload'
    end

    # Returns the default pyload group name.
    def default_pyload_group
      'pyload'
    end

    # Returns the absolute path to default pyload distribution tarball path for
    # given pyload version.
    def default_pyload_tarball_path(version)
      "#{Chef::Config['file_cache_path']}/pyload-#{version}"
    end

    # Returns the default download URL to pyload distribution tarball for given
    # pyload version.
    def default_pyload_tarball_url(version)
      urls = {
        '0.4.20' => 'https://github.com/pyload/pyload/archive/0.4.20.tar.gz',
      }
      urls[version]
    end

    # Returns the default checksum of pyload distribution tarball for given
    # pyload version.
    def default_pyload_tarball_checksum(version)
      checksums = {
        '0.4.20' => '438f9a2fc8ecb13b75f55b00192a2192c96a0a08ec1ae842cea17c7c49aab500',
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
    def default_pyload_service_name
      'pyload'
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

    # Returns python2 packages regarding the nodes platform family.
    def python2_packages
      case node['platform_family']
      when 'debian'
        %w(python python-pip virtualenv python-dev)
      when 'rhel', 'fedora'
        %w(python python-pip python-virtualenv python-devel)
      else
        raise "Unsupported platform family #{node['platform_family']}. Is it supported by this cookbook?"
      end
    end

    # Returns python3 packages regarding the nodes platform family.
    def python3_packages
      case node['platform_family']
      when 'debian'
        %w(python3 python3-pip python3-venv python3-dev)
      when 'rhel', 'fedora'
        %w(python3 python3-pip python3-devel)
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

      install_tarball_pip_match = begin
                                    find_pyload_resource!(run_context, :pyload_install_tarball_pip, resource)
                                  rescue
                                    nil
                                  end
      return install_tarball_pip_match if install_tarball_pip_match

      find_pyload_resource!(run_context, :pyload_install, resource)
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
