#
# Cookbook Name:: pyload
# Recipe:: config
#
# Copyright 2016, Dominik Jessich
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

directory node['pyload']['config_dir'] do
  owner node['pyload']['user']
  group node['pyload']['group']
  mode node['pyload']['dir_mode']
  recursive true
end

template "#{node['pyload']['config_dir']}/pyload.conf" do
  source 'pyload.conf.erb'
  owner node['pyload']['user']
  group node['pyload']['group']
  mode node['pyload']['file_mode']
  variables(
    language: node['pyload']['language'],
    download_dir: node['pyload']['download_dir'],
    user: node['pyload']['user'],
    group: node['pyload']['group'],
    dir_mode: node['pyload']['dir_mode'],
    file_mode: node['pyload']['file_mode'],
    debug_mode: node['pyload']['debug_mode'],
    use_checksum: node['pyload']['checksum'],
    min_free_space: node['pyload']['min_free_space'],
    folder_per_package: node['pyload']['folder_per_package'],
    cpu_priority: node['pyload']['cpu_priority'],
    change_downloads: node['pyload']['change_downloads'],
    change_file: node['pyload']['change_file'],
    change_user: node['pyload']['change_user'],
    change_group: node['pyload']['change_group'],
    download_bind_interface: node['pyload']['download']['bind_interface'],
    download_allow_ipv6: node['pyload']['download']['allow_ipv6'],
    download_max_connections: node['pyload']['download']['max_connections'],
    download_max_downloads: node['pyload']['download']['max_downloads'],
    download_limit_speed: node['pyload']['download']['limit_speed'],
    download_max_speed: node['pyload']['download']['max_speed'],
    download_skip_existing: node['pyload']['download']['skip_existing'],
    download_start_time: node['pyload']['download']['start_time'],
    download_end_time: node['pyload']['download']['end_time'],
    log_activated: node['pyload']['log']['activated'],
    log_dir: node['pyload']['log']['dir'],
    log_count: node['pyload']['log']['count'],
    log_size: node['pyload']['log']['size'],
    log_rotate: node['pyload']['log']['rotate'],
    proxy_activated: node['pyload']['proxy']['activated'],
    proxy_bind_address: node['pyload']['proxy']['bind_address'],
    proxy_port: node['pyload']['proxy']['port'],
    proxy_protocol: node['pyload']['proxy']['protocol'],
    proxy_user: node['pyload']['proxy']['user'],
    proxy_group: node['pyload']['proxy']['password'],
    ssl_activated: node['pyload']['ssl']['activated'],
    ssl_cert: node['pyload']['ssl']['cert'],
    ssl_key: node['pyload']['ssl']['key'],
    reconnect_activated: node['pyload']['reconnect']['activated'],
    reconnect_method: node['pyload']['reconnect']['method'],
    reconnect_start_time: node['pyload']['reconnect']['start_time'],
    reconnect_end_time: node['pyload']['reconnect']['end_time'],
    remote_activated: node['pyload']['remote']['activated'],
    remote_listen_address: node['pyload']['remote']['listen_address'],
    remote_port: node['pyload']['remote']['port'],
    remote_no_local_auth: node['pyload']['remote']['no_local_auth'],
    webinterface_activated: node['pyload']['webinterface']['activated'],
    webinterface_server_type: node['pyload']['webinterface']['server_type'],
    webinterface_listen_address: node['pyload']['webinterface']['listen_address'],
    webinterface_port: node['pyload']['webinterface']['port'],
    webinterface_template: node['pyload']['webinterface']['template'],
    webinterface_prefix: node['pyload']['webinterface']['prefix']
  )
  action :create_if_missing
end
