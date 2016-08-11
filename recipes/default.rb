#
# Cookbook Name:: pyload
# Recipe:: default
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

# preprare package manager
if platform_family?('debian')
  include_recipe 'apt'
else
  include_recipe 'yum'
  include_recipe 'yum-epel'
  include_recipe 'yum-repoforge'
end

# add user unless root
unless node['pyload']['user'].eql?('root')
  group node['pyload']['group']

  user node['pyload']['user'] do
    gid node['pyload']['group']
    home "/home/#{node['pyload']['user']}"
    system true
  end
end

# install required packages
node['pyload']['packages'].each do |pkg|
  package pkg
end

directory node['pyload']['install_dir'] do
  user node['pyload']['user']
  group node['pyload']['group']
  mode node['pyload']['dir_mode']
  recursive true
end

include_recipe "pyload::#{node['pyload']['install_flavour']}"
include_recipe 'pyload::config'
include_recipe 'pyload::service'
