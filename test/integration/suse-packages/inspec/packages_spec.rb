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

describe package('python') do
  it { should be_installed }
end

describe package('python-Beaker') do
  it { should be_installed }
end

describe package('python-beautifulsoup4') do
  it { should be_installed }
end

describe package('python-pycrypto') do
  it { should be_installed }
end

describe package('python-feedparser') do
  it { should be_installed }
end

describe package('python-flup') do
  it { should be_installed }
end

describe package('python-html5lib') do
  it { should be_installed }
end

describe package('python-Jinja2') do
  it { should be_installed }
end

describe package('python-pycurl') do
  it { should be_installed }
end

describe package('python-pyOpenSSL') do
  it { should be_installed }
end

describe package('python-qt4') do
  it { should be_installed }
end

describe package('python-simplejson') do
  it { should be_installed }
end

describe package('python-thrift') do
  it { should be_installed }
end

describe package('js') do
  it { should be_installed }
end

describe package('python-python-spidermonkey') do
  it { should be_installed }
end

describe package('rhino') do
  it { should be_installed }
end

describe package('tesseract') do
  it { should be_installed }
end

describe package('gocr') do
  it { should be_installed }
end

if os[:release].to_f < 13.2
  describe package('python-imaging') do
    it { should be_installed }
  end
else
  describe package('python-Pillow') do
    it { should be_installed }
  end
end
