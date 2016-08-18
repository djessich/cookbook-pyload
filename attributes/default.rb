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

default['pyload']['user'] = 'pyload'
default['pyload']['group'] = 'pyload'
default['pyload']['install_dir'] = '/usr/share/pyload'
default['pyload']['config_dir'] = if node['pyload']['user'] == 'root'
                                    '/root/.pyload'
                                  else
                                    "/home/#{node['pyload']['user']}/.pyload"
                                  end

default['pyload']['download_dir'] = "#{node['pyload']['config_dir']}/downloads"
default['pyload']['log_dir'] = "#{node['pyload']['config_dir']}/logs"
default['pyload']['pid_dir'] = '/var/run/pyload'
default['pyload']['dir_mode'] = '0755'
default['pyload']['file_mode'] = '0644'
default['pyload']['init_style'] = nil
default['pyload']['language'] = 'en'
default['pyload']['debug_mode'] = false
default['pyload']['min_free_space'] = 200
default['pyload']['folder_per_package'] = true
default['pyload']['cpu_priority'] = 0
default['pyload']['use_checksum'] = false

default['pyload']['packages'] = %w(
  git curl python openssl rhino python-pycurl python-jinja2 python-beaker python-simplejson python-feedparser python-html5lib
  p7zip zip unzip
)

case node['platform_family']
when 'debian'
  default['pyload']['packages'] += %w(
    python-crypto python-imaging python-bs4 tesseract-ocr tesseract-ocr-eng unrar-free p7zip-full python-qt4 python-openssl
  )
  case node['platform']
  when 'ubuntu'
    if node['platform_version'].to_f >= 14.04
      default['pyload']['packages'] += %w(python-thrift libmozjs-24-bin)
    end
  when 'debian'
    if node['platform_version'].to_f >= 8
      default['pyload']['packages'] += %w(python-thrift libmozjs-24-bin)
    end
  end
when 'rhel'
  default['pyload']['packages'] += %w(python-beautifulsoup4 tesseract PyQt4 p7zip-plugins pyOpenSSL js)
  # default['pyload']['packages'] += %w(unrar)
  default['pyload']['packages'] += if node['platform_version'].to_f < 7
                                     %w(python-crypto python-imaging)
                                   else
                                     %w(python2-crypto python-pillow)
                                   end
end
