name 'pyload'
maintainer 'Dominik Jessich'
maintainer_email 'dominik.jessich@chello.at'
license 'Apache 2.0'
description 'Installs/Configures pyload'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

%w(debian ubuntu amazon centos fedora oracle redhat scientific zlinux).each do |os|
  supports os
end

source_url 'https://github.com/djessich/pyload' if respond_to?(:source_url)
issues_url 'https://github.com/djessich/pyload/issues' if respond_to?(:issues_url)

depends 'apt', '~> 4.0.1'
depends 'yum', '~> 3.11.0'
depends 'yum-epel', '~> 0.7.0'
depends 'yum-repoforge', '~> 0.7.0'
depends 'poise-python', '~> 1.4.0'
