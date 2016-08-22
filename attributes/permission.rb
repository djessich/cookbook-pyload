#
# Cookbook Name:: pyload
# Attributes:: permission
#
# Copyright 2016, Gridtec
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

default['pyload']['permission']['user'] = nil
default['pyload']['permission']['group'] = nil
default['pyload']['permission']['dir_mode'] = '0755'
default['pyload']['permission']['file_mode'] = '0644'
default['pyload']['permission']['change_downloads'] = false
default['pyload']['permission']['change_file'] = false
default['pyload']['permission']['change_user'] = false
default['pyload']['permission']['change_group'] = false
