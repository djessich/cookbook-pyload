#
# Copyright 2019 Dominik Jessich
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

# On FreeBSD remove package curl first, if it should be installed
package 'curl' do
  action :remove
  only_if { platform_family?('freebsd') && node['pyload']['packages'].include?('curl') }
end

# Install all configured packages
node['pyload']['packages'].each do |pkg|
  package pkg
end

# When rhino has been installed (as specified in attrbiutes), ensure that
# java is installed as dependency of rhino on RHEL and SUSE unless java has
# already been installed
package 'install java-headless dependency for rhino' do
  case node['platform_family']
  when 'rhel'
    package_name 'java-1.8.0-openjdk-headless'
  when 'suse'
    package_name 'java-1_8_0-openjdk-headless'
  end
  only_if { platform_family?('rhel', 'suse') && node['pyload']['packages'].include?('rhino') }
  not_if 'command -v java >/dev/null 2>&1 || exit 1'
end

# On FreeBSD symlink python executeable in /usr/local/bin after python package
# has been installed
link '/usr/local/bin/python' do
  to '/usr/local/bin/python2.7'
  only_if { platform_family?('freebsd') }
end
