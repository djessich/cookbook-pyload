name 'pyload'
maintainer 'Gridtec'
maintainer_email 'projects@gridtec.at'
license 'Apache 2.0'
description 'Installs/Configures Pyload'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version IO.read(File.join(File.dirname(__FILE__), 'VERSION')).chomp

source_url 'https://github.com/gridtec/cookbook-pyload'
issues_url 'https://github.com/gridtec/cookbook-pyload/issues'

%w(debian ubuntu centos redhat fedora suse opensuse arch freebsd).each do |os|
  supports os
end

depends 'ark', '>= 4.0.0'

chef_version '>= 13'
