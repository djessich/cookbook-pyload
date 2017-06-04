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

# on FreeBSD we need to remove curl package first if it is set to be installed
package 'curl' do
  action :remove
end if node['platform_family'].eql?('freebsd') && node['pyload']['packages'].include?('curl')

node['pyload']['packages'].each do |pkg|
  package pkg
end

# on FreeBSD we need to manually create python executeable in /usr/local/bin
# after python package is installed
link '/usr/local/bin/python' do
  to '/usr/local/bin/python2'
  link_type :symbolic
  only_if { node['platform_family'].eql?('freebsd') }
end
