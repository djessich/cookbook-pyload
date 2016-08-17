#
# Cookbook Name:: pyload
# Attributes:: download
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

default['pyload']['download']['bind_interface'] = nil
default['pyload']['download']['allow_ipv6'] = false
default['pyload']['download']['max_connections'] = 3
default['pyload']['download']['max_downloads'] = 3
default['pyload']['download']['limit_speed'] = false
default['pyload']['download']['max_speed'] = -1
default['pyload']['download']['skip_existing'] = false
default['pyload']['download']['start_time'] = nil
default['pyload']['download']['end_time'] = nil
