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

describe systemd_service('pyload') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/systemd/system/pyload.service') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq os.family == 'bsd' ? 'wheel' : 'root' }
  its('mode') { should cmp '0644' }
end
