#
# Cookbook:: pyload
# Resource:: install
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

unified_mode true

property :instance_name, String, name_property: true
property :version, String, default: lazy { default_pyload_version }
property :install_method, String, equal_to: %w(pip source), default: lazy { default_pyload_install_method }
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
  case new_resource.install_method
  when 'pip'
    action_install_pip
  when 'source'
    action_install_source
  else
    raise "Invalid install method #{new_resource.install_method} specified."
  end
end

action :install_pip do
  pyload_install_pip new_resource.instance_name do
    copy_properties_from(new_resource, :version, :install_dir, :data_dir, :log_dir, :download_dir, :tmp_dir, :user, :group, :create_user, :create_group, :create_download_dir, :create_symlink, :sensitive)
  end
end

action :install_source do
  pyload_install_source new_resource.instance_name do
    copy_properties_from(new_resource, :version, :install_dir, :data_dir, :log_dir, :download_dir, :tmp_dir, :user, :group, :source_path, :source_url, :source_checksum, :create_user, :create_group, :create_download_dir, :create_symlink, :sensitive)
  end
end
