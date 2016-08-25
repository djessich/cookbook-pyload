#
# Cookbook Name:: pyload
# Suite:: default
# Test:: config
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

describe file('/home/pyload/.pyload/accounts.conf') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should eq 0600 }
  its('content') { should match(/Test:\n\n\ttest:test/) }
end

describe file('/home/pyload/.pyload/pyload.conf') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should eq 0600 }
  its('content') { should match(/language.*en/) }
  its('content') { should match(%r{download_folder.*/home/pyload/.pyload/downloads}) }
  its('content') { should match(/debug_mode.*False/) }
  its('content') { should match(/checksum.*False/) }
  its('content') { should match(/min_free_space.*200/) }
  its('content') { should match(/folder_per_package.*True/) }
  its('content') { should match(/renice.*0/) }
  its('content') { should match(/remote\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*activated.*True/) }
  its('content') { should match(/remote\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*listenaddr.*0\.0\.0\.0/) }
  its('content') { should match(/remote\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*port.*7227/) }
  its('content') { should match(/remote\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*nolocalauth.*True/) }
  its('content') { should match(/webinterface\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*activated.*True/) }
  its('content') { should match(/webinterface\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*server.*builtin/) }
  its('content') { should match(/webinterface\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*host.*0\.0\.0\.0/) }
  its('content') { should match(/webinterface\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*port.*8080/) }
  its('content') { should match(/webinterface\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*template.*default/) }
  its('content') { should match(/webinterface\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*prefix.*=.*/) }
  its('content') { should match(/webinterface\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*https.*False/) }
  its('content') { should match(/ssl\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*activated.*False/) }
  its('content') { should match(/ssl\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*cert.*ssl.crt/) }
  its('content') { should match(/ssl\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*key.*ssl.key/) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\"\:\;\_\=\(\)/\n\s]*interface.*None}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\"\:\;\_\=\(\)/\n\s]*ipv6.*False}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\"\:\;\_\=\(\)/\n\s]*chunks.*3}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\"\:\;\_\=\(\)/\n\s]*max_downloads.*3}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\"\:\;\_\=\(\)/\n\s]*max_speed.*-1}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\"\:\;\_\=\(\)/\n\s]*limit_speed.*False}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\"\:\;\_\=\(\)/\n\s]*skip_existing.*False}) }
  its('content') { should match(/downloadTime\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*time\sstart.*0:00/) }
  its('content') { should match(/downloadTime\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*time\send.*0:00/) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\"\:\;\_\=/\n\s]*file_log.*True}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\"\:\;\_\=/\n\s]*log_folder.*/var/log/pyload}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\"\:\;\_\=/\n\s]*log_count.*5}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\"\:\;\_\=/\n\s]*log_size.*100}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\"\:\;\_\=/\n\s]*log_rotate.*True}) }
  its('content') { should match(/permission\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*user.*pyload/) }
  its('content') { should match(/permission\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*group.*pyload/) }
  its('content') { should match(/permission\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*folder.*0755/) }
  its('content') { should match(/permission\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*file.*0644/) }
  its('content') { should match(/permission\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*change_dl.*False/) }
  its('content') { should match(/permission\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*change_file.*False/) }
  its('content') { should match(/permission\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*change_user.*False/) }
  its('content') { should match(/permission\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*change_group.*False/) }
  its('content') { should match(/reconnect\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*activated.*False/) }
  its('content') { should match(/reconnect\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*method.*None/) }
  its('content') { should match(/reconnect\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*startTime.*0:00/) }
  its('content') { should match(/reconnect\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*endTime.*0:00/) }
  its('content') { should match(/proxy\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*proxy.*False/) }
  its('content') { should match(/proxy\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*address.*localhost/) }
  its('content') { should match(/proxy\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*port.*7070/) }
  its('content') { should match(/proxy\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*type.*http/) }
  its('content') { should match(/proxy\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*username.*None/) }
  its('content') { should match(/proxy\s[a-zA-Z0-9\-\.\"\:\;\_\=\n\s]*password.*None/) }
end
