name 'pyload'
maintainer 'Dominik Jessich'
maintainer_email 'dominik.jessich@chello.at'
license 'Apache-2.0'
description 'Installs/Configures Pyload'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version IO.read(File.join(File.dirname(__FILE__), 'VERSION')).chomp

source_url 'https://github.com/djessich/cookbook-pyload'
issues_url 'https://github.com/djessich/cookbook-pyload/issues'

%w(ubuntu debian redhat centos fedora suse opensuse opensuseleap oracle freebsd).each do |os|
  supports os
end

depends 'ark', '>= 4.0.0'

chef_version '>= 13'
