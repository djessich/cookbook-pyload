name 'pyload'
maintainer 'Dominik Jessich'
maintainer_email 'dominik.jessich@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures Pyload'
version '2.0.1'

source_url 'https://github.com/djessich/cookbook-pyload'
issues_url 'https://github.com/djessich/cookbook-pyload/issues'

%w(centos debian fedora opensuseleap oracle redhat suse ubuntu).each do |os|
  supports os
end

depends 'yum-epel', '>= 3.3.0'

chef_version '>= 15'
