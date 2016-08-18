#
# Cookbook Name:: pyload
# Suite:: default
# Test:: package
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

describe package('git') do
  it { should be_installed }
end

describe package('curl') do
  it { should be_installed }
end

describe package('python') do
  it { should be_installed }
end

describe package('openssl') do
  it { should be_installed }
end

describe package('rhino') do
  it { should be_installed }
end

describe package('python-pycurl') do
  it { should be_installed }
end

describe package('python-jinja2') do
  it { should be_installed }
end

describe package('python-beaker') do
  it { should be_installed }
end

describe package('python-simplejson') do
  it { should be_installed }
end

describe package('python-feedparser') do
  it { should be_installed }
end

describe package('python-html5lib') do
  it { should be_installed }
end

describe package('p7zip') do
  it { should be_installed }
end

describe package('zip') do
  it { should be_installed }
end

describe package('unzip') do
  it { should be_installed }
end
