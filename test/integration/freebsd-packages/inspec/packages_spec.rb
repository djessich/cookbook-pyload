#
# Cookbook Name:: pyload
# Suite:: freebsd-packages
# Test:: packages
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

describe package('openssl') do
  it { should be_installed }
end

describe package('python27') do
  it { should be_installed }
end

describe package('py27-beaker') do
  it { should be_installed }
end

describe package('py27-beautifulsoup') do
  it { should be_installed }
end

describe package('py27-pycrypto') do
  it { should be_installed }
end

describe package('python-django') do
  it { should be_installed }
end

describe package('py27-feedparser') do
  it { should be_installed }
end

describe package('py27-flup') do
  it { should be_installed }
end

describe package('py27-html5lib') do
  it { should be_installed }
end

describe package('py27-pillow') do
  it { should be_installed }
end

describe package('py27-Jinja2') do
  it { should be_installed }
end

describe package('py27-pycurl') do
  it { should be_installed }
end

describe package('py27-openssl') do
  it { should be_installed }
end

describe package('py27-qt4') do
  it { should be_installed }
end

describe package('py27-simplejson') do
  it { should be_installed }
end

describe package('py27-thrift') do
  it { should be_installed }
end

describe package('spidermonkey24') do
  it { should be_installed }
end

describe package('rhino') do
  it { should be_installed }
end

describe package('tesseract') do
  it { should be_installed }
end

describe package('tesseract-data') do
  it { should be_installed }
end

describe package('gocr') do
  it { should be_installed }
end

describe package('py27-sqlite3') do
  it { should be_installed }
end
