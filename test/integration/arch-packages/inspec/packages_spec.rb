#
# Cookbook Name:: pyload
# Suite:: arch-packages
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

describe package('python2') do
  it { should be_installed }
end

describe package('python2-beaker') do
  it { should be_installed }
end

describe package('python2-beautifulsoup4') do
  it { should be_installed }
end

describe package('python2-crypto') do
  it { should be_installed }
end

describe package('python2-feedparser') do
  it { should be_installed }
end

describe package('python2-flup') do
  it { should be_installed }
end

describe package('python2-html5lib') do
  it { should be_installed }
end

describe package('python2-pillow') do
  it { should be_installed }
end

describe package('python2-jinja2') do
  it { should be_installed }
end

describe package('python2-pycurl') do
  it { should be_installed }
end

describe package('python2-pyopenssl') do
  it { should be_installed }
end

describe package('python2-pyqt4') do
  it { should be_installed }
end

describe package('python2-simplejson') do
  it { should be_installed }
end

describe package('python2-thrift') do
  it { should be_installed }
end

describe package('js') do
  it { should be_installed }
end

describe package('rhino') do
  it { should be_installed }
end

describe package('tesseract') do
  it { should be_installed }
end

describe package('tesseract-git') do
  it { should be_installed }
end

describe package('tesseract-ocr-git') do
  it { should be_installed }
end
