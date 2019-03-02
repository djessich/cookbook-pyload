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

describe package('curl') do
  it { should be_installed }
end

describe package('openssl') do
  it { should be_installed }
end

describe package('python2') do
  it { should be_installed }
end

# describe package('python-beaker') do
#   it { should be_installed }
# end

# describe package('python-beautifulsoup4') do
#   it { should be_installed }
# end

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

describe package('python2-notify') do
  it { should be_installed }
end

describe package('python2-pycurl') do
  it { should be_installed }
end

describe package('python2-pyOpenSSL') do
  it { should be_installed }
end

describe package('PyQt4') do
  it { should be_installed }
end

# describe package('python-thrift') do
#   it { should be_installed }
# end

# describe package('js') do
#   it { should be_installed }
# end

describe package('python2-simplejson') do
  it { should be_installed }
end

describe package('rhino') do
  it { should be_installed }
end

describe package('tesseract') do
  it { should be_installed }
end

# describe package('gocr') do
#   it { should be_installed }
# end

# if os[:release].to_f < 24
#   describe package('python-crypto') do
#     it { should be_installed }
#   end
#
#   # describe package('python-django') do
#   #   it { should be_installed }
#   # end
#
#   # describe package('python-jinja2') do
#   #   it { should be_installed }
#   # end
# else
#   describe package('python2-crypto') do
#     it { should be_installed }
#   end
#
#   # describe package('python2-django') do
#   #   it { should be_installed }
#   # end
#
#   # describe package('python2-jinja2') do
#   #   it { should be_installed }
#   # end
# end

# if os[:release].to_f < 25
#   describe package('python-pillow') do
#     it { should be_installed }
#   end
#
#   describe package('python-pycurl') do
#     it { should be_installed }
#   end
#
#   describe package('python-simplejson') do
#     it { should be_installed }
#   end
# else
#   describe package('python2-pillow') do
#     it { should be_installed }
#   end
#
#   describe package('python2-pycurl') do
#     it { should be_installed }
#   end
#
#   describe package('python2-simplejson') do
#     it { should be_installed }
#   end
# end
