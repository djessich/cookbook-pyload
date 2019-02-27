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
when 'arch'
  default['pyload']['packages'] = %w(
    curl openssl python2 python2-beaker python2-beautifulsoup4 python2-crypto python2-django
    python2-feedparser python2-flup python2-html5lib python2-pillow python2-pycurl
    python2-pyopenssl python2-pyqt4 python2-simplejson thrift js rhino tesseract gocr
  )
when 'debian'
  default['pyload']['install_method'] = 'package'
  default['pyload']['packages'] = %w(
    curl openssl python python-beaker python-bs4 python-crypto python-django python-feedparser
    python-flup python-html5lib python-imaging python-pycurl python-openssl python-qt4
    python-simplejson rhino tesseract-ocr tesseract-ocr-eng gocr
  )
  case node['platform']
  when 'debian'
    default['pyload']['packages'] += if node['platform_version'].to_f < 8
                                       %w(libmozjs185-1.0)
                                     else
                                       %w(python-thrift libmozjs-24-bin)
                                     end
  when 'ubuntu'
    default['pyload']['packages'] += if node['platform_version'].to_f < 14.04
                                       %w(libmozjs185-1.0)
                                     else
                                       %w(python-thrift libmozjs-24-bin)
                                     end
  end
when 'fedora'
  default['pyload']['packages'] = %w(
    curl openssl python python-beaker python-beautifulsoup4 python-feedparser python-flup
    python-html5lib pyOpenSSL PyQt4 python-thrift js rhino tesseract gocr
  )
  default['pyload']['packages'] += if node['platform_version'].to_f < 24
                                     %w(python-crypto python-django)
                                   else
                                     %w(python2-crypto python2-django)
                                   end
  default['pyload']['packages'] += if node['platform_version'].to_f < 25
                                     %w(python-pillow python-pycurl python-simplejson)
                                   else
                                     %w(python2-pillow python2-pycurl python2-simplejson)
                                   end
when 'freebsd'
  default['pyload']['packages'] = %w(
    curl openssl python27 py27-beaker py27-beautifulsoup py27-pycrypto py27-django19
    py27-feedparser py27-flup py27-html5lib py27-pillow py27-pycurl py27-openssl py27-qt4
    py27-simplejson py27-thrift spidermonkey24 rhino tesseract gocr py27-sqlite3
  )
when 'rhel'
  default['pyload']['packages'] = %w(
    curl openssl python python-beaker python-beautifulsoup4 python-feedparser python-flup
    python-html5lib python-pycurl pyOpenSSL PyQt4 js rhino tesseract
  )
  default['pyload']['packages'] += if node['platform_version'].to_f < 7
                                     %w(python-crypto Django python-imaging python-simplejson)
                                   else
                                     %w(python2-crypto python-django python-pillow python2-simplejson python-thrift)
                                   end
when 'suse'
  default['pyload']['use_fix']     = true
  default['pyload']['packages'] = %w(
    curl openssl python python-Beaker python-beautifulsoup4 python-pycrypto python-django
    python-feedparser python-flup python-html5lib python-pycurl python-pyOpenSSL python-qt4
    python-simplejson python-thrift js python-python-spidermonkey rhino tesseract gocr
  )
  default['pyload']['packages'] += if node['platform_version'].to_f < 13.2
                                     %w(python-imaging)
                                   else
                                     %w(python-Pillow)
                                   end
# else
#   default['pyload']['init_style']  = 'none'
#   default['pyload']['python_exec'] = '/usr/bin/python'
#   default['pyload']['pid_dir']     = '/var/run'
#   default['pyload']['log_dir']     = '/var/log/pyload'
#   default['pyload']['packages']    = %w(
#     git curl openssl python python-beaker python-beautifulsoup4 python-crypto python-django python-feedparser
#     python-flup python-html5lib python-imaging python-jinja2 python-pycurl python-openssl python-simplejson
#     rhino tesseract gocr
#   )
end
