#
# Cookbook Name:: pyload
# Attributes:: default
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

default['pyload']['version'] = 'stable'
default['pyload']['user'] = 'pyload'
default['pyload']['group'] = 'pyload'
default['pyload']['install_dir'] = '/usr/share/pyload'
default['pyload']['config_dir'] = if node['pyload']['user'] == 'root'
                                    '/root/.pyload'
                                  else
                                    "/home/#{node['pyload']['user']}/.pyload"
                                  end
default['pyload']['download_dir'] = "#{node['pyload']['config_dir']}/downloads"
default['pyload']['dir_mode'] = '0755'
default['pyload']['file_mode'] = '0644'

default['pyload']['accounts'] = {}

default['pyload']['language'] = 'en'
default['pyload']['debug_mode'] = false
default['pyload']['min_free_space'] = 200
default['pyload']['folder_per_package'] = true
default['pyload']['cpu_priority'] = 0
default['pyload']['use_checksum'] = false

case node['platform_family']
when 'arch'
  default['pyload']['init_style'] = 'systemd'
  default['pyload']['pid_dir']    = '/var/run/pyload'
  default['pyload']['log_dir']    = '/var/log/pyload'
  default['pyload']['packages']   = %w(
    git curl openssl python2 python2-beaker python2-beautifulsoup4 python2-crypto python2-django python2-feedparser
    python2-flup python2-html5lib python2-pillow python2-jinja python2-pycurl python2-pyopenssl python2-pyqt4
    python2-simplejson python2-thrift js rhino tesseract tesseract-git tesseract-ocr-git gocr
  )
when 'debian'
  default['pyload']['init_style'] = node['init_package']
  default['pyload']['pid_dir']    = '/var/run/pyload'
  default['pyload']['log_dir']    = '/var/log/pyload'
  default['pyload']['packages']   = %w(
    git curl openssl python python-beaker python-bs4 python-crypto python-django python-feedparser python-flup
    python-html5lib python-imaging python-jinja2 python-pycurl python-openssl python-qt4 python-simplejson rhino
    tesseract-ocr tesseract-ocr-eng gocr
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
  default['pyload']['init_style'] = 'systemd'
  default['pyload']['pid_dir']    = '/var/run/pyload'
  default['pyload']['log_dir']    = '/var/log/pyload'
  default['pyload']['packages']   = %w(
    git curl openssl python python-beaker python-beautifulsoup4 python-feedparser python-flup python-html5lib
    python-pillow python-pycurl pyOpenSSL PyQt4 python-simplejson python-thrift js rhino tesseract gocr
  )
  default['pyload']['packages'] += if node['platform_version'].to_f < 24
                                     %w(python-crypto python-django python-jinja2)
                                   else
                                     %w(python2-crypto python2-django python2-jinja2)
                                   end
when 'freebsd'
  default['pyload']['init_style'] = 'bsd'
  default['pyload']['pid_dir']    = '/var/run'
  default['pyload']['log_dir']    = '/var/log/pyload'
  default['pyload']['packages']   = %w(
    git curl openssl python27 py27-beaker py27-beautifulsoup py27-pycrypto py27-django19 py27-feedparser py27-flup
    py27-html5lib py27-pillow py27-Jinja2 py27-pycurl py27-openssl py27-qt4 py27-simplejson py27-thrift
    spidermonkey24 rhino tesseract tesseract-data gocr py27-sqlite3
  )
when 'rhel'
  default['pyload']['init_style'] = node['init_package']
  default['pyload']['pid_dir']    = '/var/run/pyload'
  default['pyload']['log_dir']    = '/var/log/pyload'
  default['pyload']['packages']   = %w(
    git curl openssl python python-beaker python-beautifulsoup4 python-feedparser python-flup python-html5lib
    python-jinja2 python-pycurl pyOpenSSL PyQt4 python-simplejson js rhino tesseract
  )
  default['pyload']['packages'] += if node['platform_version'].to_f < 7
                                     %w(python-crypto Django python-imaging)
                                   else
                                     %w(python2-crypto python-django python-pillow python-thrift)
                                   end
when 'suse'
  default['pyload']['init_style'] = 'systemd'
  default['pyload']['pid_dir']    = '/var/run/pyload'
  default['pyload']['log_dir']    = '/var/log/pyload'
  default['pyload']['use_fix']    = true
  default['pyload']['packages']   = %w(
    git curl openssl python python-Beaker python-beautifulsoup4 python-pycrypto python-django python-feedparser
    python-flup python-html5lib python-Jinja2 python-pycurl python-pyOpenSSL python-qt4 python-simplejson
    python-thrift js python-python-spidermonkey rhino tesseract gocr
  )
  default['pyload']['packages'] += if node['platform_version'].to_f < 13.2
                                     %w(python-imaging)
                                   else
                                     %w(python-Pillow)
                                   end
else
  default['pyload']['init_style'] = 'none'
  default['pyload']['pid_dir']    = '/var/run'
  default['pyload']['log_dir']    = '/var/log/pyload'
  default['pyload']['packages']   = %w(
    git curl openssl python python-beaker python-beautifulsoup4 python-crypto python-django python-feedparser
    python-flup python-html5lib python-imaging python-jinja2 python-pycurl python-openssl python-simplejson
    rhino tesseract gocr
  )
end
