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

default['pyload']['version'] = 'stable'
default['pyload']['install_method'] = 'git'
default['pyload']['user'] = 'pyload'
default['pyload']['group'] = 'pyload'
default['pyload']['install_dir'] = '/opt/pyload'
default['pyload']['conf_dir'] = if node['pyload']['user'] == 'root'
                                  '/root/.pyload'
                                else
                                  "/home/#{node['pyload']['user']}/.pyload"
                                end
default['pyload']['pid_dir'] = '/var/run/pyload'
default['pyload']['log_dir'] = '/var/log/pyload'
default['pyload']['download_dir'] = '/tmp/downloads'
default['pyload']['urls'] = {
  '0.4.9' => 'https://github.com/pyload/pyload/archive/v0.4.9.tar.gz',
}
default['pyload']['checksums'] = {
  '0.4.9' => '1a7248082bff8d1717a23049ebe2070a18fd727435a849e0450e82ca3f478017',
}

case node['platform_family']
# when 'arch'
#   default['pyload']['packages'] = %w(
#     curl openssl python2 python2-crypto python2-feedparser python2-flup
#     python2-html5lib python2-pillow python2-notify python2-pycurl
#     python2-pyopenssl python2-pyqt4 python2-simplejson rhino tesseract
#   )
when 'debian'
  default['pyload']['packages'] = %w(
    curl openssl python python-crypto python-feedparser python-flup
    python-html5lib python-pil python-notify python-pycurl python-openssl
    python-qt4 python-simplejson rhino tesseract-ocr tesseract-ocr-eng
  )
when 'fedora'
  default['pyload']['packages'] = %w(
    curl openssl python2 python2-crypto python2-feedparser python2-flup
    python2-html5lib python2-pillow python2-notify python2-pycurl python2-pyOpenSSL
    PyQt4 python2-simplejson rhino tesseract
  )
when 'freebsd'
  default['pyload']['packages'] = %w(
    curl openssl python27 py27-pycrypto py27-feedparser py27-flup6 py27-html5lib
    py27-pillow py27-notify py27-pycurl py27-openssl py27-qt4 py27-simplejson
    rhino tesseract py27-sqlite3
  )
when 'rhel'
  default['pyload']['packages'] = %w(
    curl openssl python python-feedparser python-flup python-html5lib
    notify-python python-pycurl pyOpenSSL PyQt4 rhino tesseract
  )
  default['pyload']['packages'] += if node['platform_version'].to_f < 7
                                     %w(python-crypto python-imaging python-simplejson)
                                   else
                                     %w(python2-crypto python-pillow python2-simplejson)
                                   end
when 'suse'
  default['pyload']['packages'] = %w(
    curl openssl python python-pycrypto python-feedparser python-flup python-html5lib
    python-notify python-pycurl python-pyOpenSSL python-qt4 python-simplejson
    rhino tesseract
  )
  default['pyload']['packages'] += if node['platform_version'].to_f < 13.2
                                     %w(python-imaging)
                                   else
                                     %w(python-Pillow)
                                   end
else
  raise 'Could not determine your platform; is it supported by this cookbook?'
end
