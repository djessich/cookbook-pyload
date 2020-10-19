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
  end
end
