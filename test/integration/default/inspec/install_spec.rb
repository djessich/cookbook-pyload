#
# Cookbook Name:: pyload
# Suite:: default
# Test:: default
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

describe file('/usr/share/pyload') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should eq 0755 }
end

describe file('/var/run/pyload') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should eq 0755 }
end

describe file('/usr/bin/pyLoadCli') do
  it { should exist }
  it { should be_symlink }
  it { should_not be_file }
  it { should_not be_directory }
  it { should be_linked_to '/usr/share/pyload/pyLoadCli.py' }
end

describe file('/usr/bin/pyLoadCore') do
  it { should exist }
  it { should be_symlink }
  it { should_not be_file }
  it { should_not be_directory }
  it { should be_linked_to '/usr/share/pyload/pyLoadCore.py' }
end

describe file('/usr/bin/pyLoadGui') do
  it { should exist }
  it { should be_symlink }
  it { should_not be_file }
  it { should_not be_directory }
  it { should be_linked_to '/usr/share/pyload/pyLoadGui.py' }
end
