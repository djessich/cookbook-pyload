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

package 'git' do
  it { should be_installed }
end

describe file('/opt/pyload') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'root' }
  its('group') { should eq os.family == 'bsd' ? 'wheel' : 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload/pyLoadCli.py') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq os.family == 'bsd' ? 'wheel' : 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload/pyLoadCore.py') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq os.family == 'bsd' ? 'wheel' : 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload/pyLoadGui.py') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq os.family == 'bsd' ? 'wheel' : 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/var/log/pyload') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should cmp '0755' }
end

describe file('/var/run/pyload') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should cmp '0755' }
end

describe file('/usr/bin/pyLoadCli') do
  it { should exist }
  it { should be_symlink }
  it { should be_linked_to '/opt/pyload/pyLoadCli.py' }
  its('owner') { should eq 'root' }
  its('group') { should eq os.family == 'bsd' ? 'wheel' : 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/usr/bin/pyLoadCore') do
  it { should exist }
  it { should be_symlink }
  it { should be_linked_to '/opt/pyload/pyLoadCore.py' }
  its('owner') { should eq 'root' }
  its('group') { should eq os.family == 'bsd' ? 'wheel' : 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/usr/bin/pyLoadGui') do
  it { should exist }
  it { should be_symlink }
  it { should be_linked_to '/opt/pyload/pyLoadGui.py' }
  its('owner') { should eq 'root' }
  its('group') { should eq os.family == 'bsd' ? 'wheel' : 'root' }
  its('mode') { should cmp '0755' }
end

describe command('python') do
  it { should exist }
end

describe command("echo '\n' | python /opt/pyload/systemCheck.py") do
  its('stdout') { should_not match(/missing/) }
end
