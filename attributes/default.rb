#
# Cookbook Name:: pyload
# Attributes:: default
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

default['pyload']['install_dir'] = '/usr/share/pyload'
default['pyload']['download_dir'] = 'Downloads'
default['pyload']['pid_file'] = '/var/run/pyload.pid'
default['pyload']['user'] = 'pyload'
default['pyload']['group'] = 'pyload'
default['pyload']['dir_mode'] = '0755'
default['pyload']['file_mode'] = '0644'
default['pyload']['init_style'] = nil
default['pyload']['language'] = 'en'
default['pyload']['debug_mode'] = false
default['pyload']['min_free_space'] = 200
default['pyload']['folder_per_package'] = true
default['pyload']['cpu_priority'] = 0
default['pyload']['change_downloads'] = false
default['pyload']['change_file'] = false
default['pyload']['change_user'] = false
default['pyload']['change_group'] = false
default['pyload']['use_checksum'] = false

default['pyload']['config_dir'] = if node['pyload']['user'] == 'root'
                                    '/root/.pyload'
                                  else
                                    "/home/#{node['pyload']['user']}/.pyload"
                                  end
