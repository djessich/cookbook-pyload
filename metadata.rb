name 'pyload'
maintainer 'Gridtec'
maintainer_email 'projects@gridtec.at'
license 'Apache 2.0'
description 'Installs/Configures Pyload'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

%w(debian ubuntu redhat centos fedora scientific).each do |os|
  supports os
end

source_url 'https://github.com/djessich/pyload' if respond_to?(:source_url)
issues_url 'https://github.com/djessich/pyload/issues' if respond_to?(:issues_url)
