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
default['pyload']['install_dir'] = '/usr/share/pyload'
default['pyload']['conf_dir'] = if node['pyload']['user'] == 'root'
                                  '/root/.pyload'
                                else
                                  "/home/#{node['pyload']['user']}/.pyload"
                                end
default['pyload']['pid_dir'] = '/var/run/pyload'
default['pyload']['download_dir'] = '/tmp/downloads'
default['pyload']['log_dir'] = '/var/log/pyload'

case node['platform_family']
when 'arch' # python2-beaker thrift python2-beautifulsoup4 js gocr
  default['pyload']['packages'] = %w(
    curl openssl python2 python2-crypto python2-feedparser python2-flup
    python2-html5lib python2-imaging python2-notify python2-pycurl
    python2-pyopenssl python2-pyqt python2-simplejson rhino tesseract
  )
when 'debian' # python-beaker python-bs4 gocr
  default['pyload']['packages'] = %w(
    curl openssl python python-crypto python-feedparser python-flup
    python-html5lib python-pil python-notify python-pycurl python-openssl
    python-qt4 python-simplejson rhino tesseract-ocr tesseract-ocr-eng
  )
  # case node['platform']
  # when 'debian'
  #   default['pyload']['packages'] += if node['platform_version'].to_f < 8
  #                                      %w(libmozjs185-1.0)
  #                                    else # python-thrift
  #                                      %w(libmozjs-24-bin)
  #                                    end
  # when 'ubuntu'
  #   default['pyload']['packages'] += if node['platform_version'].to_f < 14.04
  #                                      %w(libmozjs185-1.0)
  #                                    else # python-thrift
  #                                      %w(libmozjs-24-bin)
  #                                    end
  # end
when 'fedora' # python-beaker python-thrift python-beautifulsoup4 js  gocr
  default['pyload']['packages'] = %w(
    curl openssl python2 python2-crypto python2-feedparser python2-flup
    python2-html5lib python2-pillow python2-notify python2-pycurl python2-pyOpenSSL
    PyQt4 python2-simplejson rhino tesseract
  )
when 'freebsd' # py27-beaker py27-thrift py27-beautifulsoup spidermonkey24 gocr
  default['pyload']['packages'] = %w(
    curl openssl python27 py27-pycrypto py27-feedparser py27-flup6 py27-html5lib
    py27-pillow py27-notify py27-pycurl py27-openssl py27-qt4 py27-simplejson
    rhino tesseract py27-sqlite3
  )
when 'rhel' # python-beaker python-beautifulsoup4 js
  default['pyload']['packages'] = %w(
    curl openssl python python-feedparser python-flup python-html5lib
    notify-python python-pycurl pyOpenSSL PyQt4 rhino tesseract
  )
  default['pyload']['packages'] += if node['platform_version'].to_f < 7
                                     %w(python-crypto python-imaging python-simplejson)
                                   else # python-thrift
                                     %w(python2-crypto python-pillow python2-simplejson)
                                   end
when 'suse' # python-Beaker python-thrift python-beautifulsoup4 python-python-spidermonkey js  gocr
  default['pyload']['use_fix'] = true
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
