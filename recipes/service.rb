#
# Cookbook Name:: pyload
# Recipe:: service
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

init_styles = %w(
  init
  systemd
)

init_style = node['pyload']['init_style']

if init_styles.include?(init_style)
  include_recipe "pyload::#{init_style}_service"
else
  log "Could not determine service init style #{init_style}, manual intervention required to start up the pyload service."
end
