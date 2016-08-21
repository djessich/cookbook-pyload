# Pyload Cookbook

[![Build Status](https://travis-ci.org/gridtec/cookbook-pyload.svg?branch=master)](https://travis-ci.org/gridtec/cookbook-pyload)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

This cookbook is used to install and configure [Pyload](https://github.com/pyload/pyload) on a system. Just put it in your nodes `run_list` or the default recipe using `include_recipe`. This cookbook installs Pyload from Git repository (stable branch), installs all required dependencies for Pyload, prepares configuration folder and files and installs the appropriate configuration for your platform's init system.

## Requirements

### Platforms

* ArchLinux
* CentOS 6+
* Debian 7+
* Fedora 22+
* openSUSE 13+
* RHEL 6+
* Ubuntu 12.04+

#### Note on Fedora:

As everything works on Red Hat Enterprise Linux (RHEL) and derivatives, it is assumed that this cookbook also works on Fedora 23+.

### Chef

Chef 12.5+

### Cookbooks

This cookbook has no direct external dependencies.

Regarding your OS, you may need additional recipes or cookbooks for this cookbook's recipes to converge on the node. In particular, the following things should be considered.

* On Debian/Ubuntu, use the [apt](https://github.com/chef-cookbooks/apt) cookbook to ensure the package cache is updated so Chef can install packages, or consider putting apt-get in your bootstrap process or knife bootstrap template. Otherwise this cookbook won't install latest versions of Pyload dependencies using sysem package manager (apt).
* On Red Hat Enterprise Linux (RHEL) and derivatives, some 3rd party repositories may be necessary to be installed and enabled in yum to install required packages/dependencies for Pyload used in certain recipes of this cookbook. The [yum](https://github.com/chef-cookbooks/yum) and [yum-epel](https://github.com/chef-cookbooks/yum-epel) cookbooks are therefore suggested to be in your `run_list`.

## Attributes

The attributes used by this cookbook are in the `node['pyload']` namespace which is broken up into different groups.

### General Settings

The `node['pyload']` global namespace defines general settings for this cookbook.

* `node['pyload']['install_dir']` - Specifies the location for Pyload package itself. By default, this is set to */usr/share/pyload*.
* `node['pyload']['config_dir']` - Specifies the location for Pyload configuration folders and files. By default, this is set to */home/&lt;user&gt;/.pyload* (interpolates to */home/pyload/.pyload* if defaults are used).
* `node['pyload']['download_dir']` - Specifies the location for all Pyload downloaded files. By default, this is set to *node['pyload']['config_dir']/downloads* (interpolates to */home/pyload/.pyload/downloads* if defaults are used).
* `node['pyload']['pid_dir']` - Specifies the location of the PID file for Pyload. By default, this is set to */var/run/pyload*.
* `node['pyload']['log_dir']` - Specifies the location where log files will be placed. By default, this is set to */var/log/pyload*.
* `node['pyload']['user']` - Specifies the user which is used to run Pyload. By default, this is set to *pyload*.
* `node['pyload']['group']` - Specifies the group which is used to run Pyload. By default, this is set to *pyload*.
* `node['pyload']['dir_mode']` - Specifies the mode for folders created by this cookbook. By default, this is set to *0755*.
* `node['pyload']['file_mode']` - Specifies the mode for files created by this cookbook. By default, this is set to *0644*.
* `node['pyload']['init_style']` - Specifies the platforms init system type which can be either set to `init` or `systemd`. If something else is specified, no install script will be created. By default, the correct init system type is determined by this cookbook itself, which means that this attribute should not be required to be set manually.
<!-- TODO: Only for platform, no use of plattform family at all -->
* `node['pyload']['packages']` - Specifies a list of dependencies of Pyload which are required to successfully start Pyload. The correct package names are determined by this cookbook, regarding platform and platfom version. By default, this is set to all required dependencies for Pyload, including optional ones, which can be examined at Pyload repository or in the corresponding attribute file of this cookbook.

<!-- TODO: Move these to global attributes file -->
The `node['pyload']` global namespace also defines the following general settings for Pyload, which will be set in *pyload.conf* configuration file.

* `node['pyload']['language']` - Specifies Pyload language. Allowed values are `en`, `de`, `fr`, `it`, `es`, `nl`, `sv`, `ru`, `pl`, `cs`, `sr`, `pt_BR`. If something else is specified, Pyload may not start. By default, this is set to *en*.
* `node['pyload']['debug_mode']` - Specifies if Pyload should be started in debug mode. By default, this is set to *false*.
* `node['pyload']['min_free_space']` - Specifies the minimum of free space required in the downloads location (specified in `node['pyload']['download_dir']`) in MB. By default, this is set to *200*.
* `node['pyload']['folder_per_package']` - Specifies if each download should be saved in a folder in the downloads loation (specified in `node['pyload']['download_dir']`). By default, this is set to *true*.
* `node['pyload']['cpu_priority']` - Specifies the CPU priority of the Pyload process. By default, this is set to *0*.
* `node['pyload']['use_checksum']` - Specifies if Pyload should use checksums. By default, this is set to *false*.

### Download Settings

The `node['pyload']['download']` namespace defines download settings for Pyload, which will be set in *pyload.conf* configuration file.

* `node['pyload']['download']['bind_interface']` - Specifies the download interface to bind to, which can be represented by an interface name or an ip. If this is set to *None*, there is no specific binding defined. By default, this is set to *nil*.
* `node['pyload']['download']['allow_ipv6']` - Specifies if IPv6 should be allowed. By default, this is set to *false*.
* `node['pyload']['download']['max_connections']` - Specifies the maximum of connections for downloads. By default, this is set to *3*.
* `node['pyload']['download']['max_downloads']` - Specifies the maximum of parallel downloads. By default, this is set to *3*.
* `node['pyload']['download']['limit_speed']` - Specifies if the download speed should be limited. By default, the is no limit, which means that this is set to *false*.
* `node['pyload']['download']['max_speed']` - Specifies the global, maximmum allowed speed. By default, there is no limit, which means that this is set to *-1*.
* `node['pyload']['download']['skip_existing']` - Specifies if already downloaded files should be skipped, to avoid redownload. By default, this is set to *false*.
* `node['pyload']['download']['start_time']` - Specifies the download start time in &lt;hour&gt;:&lt;min&gt; format. By default, this is set to *nil*.
* `node['pyload']['download']['end_time']` - Specifies the download end time in &lt;hour&gt;:&lt;min&gt; format. By default, this is set to *nil*.

### Logging Settings

The `node['pyload']['database']` namespace defines logging settings for Pyload, which will be set in *pyload.conf* configuration file.

* `node['pyload']['log']['activated']` - Enables or disables logging. By default, this is enabled, which means that this is set to *true*.
* `node['pyload']['log']['count']` - Specifies the maximum allowed logging files to keep, until they get deleted. By default, this is set to *5*.
* `node['pyload']['log']['size']` - Specifies the maximum size of the log files in KB. By default, this is set to *100*.
* `node['pyload']['log']['rotate']` - Specifies if logfiles should be rotated. This means, that the standard log file name represents the last logging output. By default, this is enabled, which means, that this is set to *true*.

### Permission Settings

The `node['pyload']['permission']` namespace defines permissive settings for Pyload, which will be set in *pyload.conf* configuration file.

* `node['pyload']['permission']['user']` - Specifies the username which will be set for all downloads. By default, this is set to *user*, which represents just a dummy. Its recommended to set this to another value.
* `node['pyload']['permission']['group']` - Specifies the groupname which will be set for all downloads. By default, this is set to *users*, which represents just a dummy. Its recommended to set this to another value.
* `node['pyload']['permission']['dir_mode']` - Specifies the directory mode which will be set for all downloads. By default, this is set to *0755*.
* `node['pyload']['permission']['file_mode']` - Specifies the file mode which will be set for all downloads. By default, this is set to *0644*.
* `node['pyload']['permission']['change_downloads']` - Specifies if the user and group of a downloaded package should be changed. By default, this is set to *false*.
* `node['pyload']['permission']['change_file']` - Specifies if the file mode of a downloaded package should changed. By default, this is set to *false*.
* `node['pyload']['permission']['change_user']` - Specifies if the user of the running process should be changed to the user specified in `node['pyload']['permission']['user']`. By default, this is set to *false*.
* `node['pyload']['permission']['change_group']` - Specifies if the group of the running process should be changed to the group specified in `node['pyload']['permission']['group']`. By default, this is set to *false*.

### Proxy Settings

The `node['pyload']['proxy']` namespace defines proxy settings for Pyload, which will be set in *pyload.conf* configuration file.

* `node['pyload']['proxy']['activated']` - Enables or disables the use of a proxy. By default, this is disabled, which means that this is set to *false*.
* `node['pyload']['proxy']['bind_address']` - Specifies the proxy address to bind to. By default, this is set to *localhost*.
* `node['pyload']['proxy']['port']` - Specifies the proxy port to connect to. By default, this is set to *7070*.
* `node['pyload']['proxy']['protocol']` - Specifies the proxy protocol used to connect to the proxy. Allowed values are `http`, `socks4` and `socks5`. By default, this is set to *http*.
* `node['pyload']['proxy']['user']` - Specifies the user to authenticate at the proxy. By default, this is set to *nil*.
* `node['pyload']['proxy']['password']` - Specifies the password of the user which authenticates at the proxy. By default, this is set to *nil*.

### Reconnect Settings

The `node['pyload']['reconnect']` namespace defines reconnect settings for Pyload, which will be set in *pyload.conf* configuration file.

* `node['pyload']['reconnect']['activated']` - Enables or disables the use of reconnects. By default, this is disabled, which means that this is set to *false*.
* `node['pyload']['reconnect']['method']` - Specifies the reconnect method. By default, this is set to *nil*.
* `node['pyload']['reconnect']['start_time']` - Specifies the reconnect start time in &lt;hour&gt;:&lt;min&gt; format. By default, this is set to *nil*.
* `node['pyload']['reconnect']['end_time']` - Specifies the reconnect end time in &lt;hour&gt;:&lt;min&gt; format. By default, this is set to *nil*.

### Remote Settings

The `node['pyload']['remote']` namespace defines remote API settings for Pyload, which will be set in *pyload.conf* configuration file.

* `node['pyload']['remote']['activated']` - Enables or disables remote API. By default, this is enabled, which means that this is set to *true*.
* `node['pyload']['remote']['listen_address']` - Specifies the address on which the remote API should listen on. By default, this is set to *0.0.0.0*.
* `node['pyload']['remote']['port']` - Specifies the port for the remote API to connect to. By default, this is set to *7227*.
* `node['pyload']['remote']['no_local_auth']` - Specifies if local connections to remote API does not require authentication. By default, local connections do not require authentication, which means that this is set to *true*.

### SSL Settings

The `node['pyload']['ssl']` namespace defines SSL settings for Pyload, which will be set in *pyload.conf* configuration file.

* `node['pyload']['ssl']['activated']` - Enables or disables SSL. By default, this is disabled, which means that this is set to *false*.
* `node['pyload']['ssl']['cert_path']` - Specifies the path where SSL certificates should be searched for. This is set to *nil*, which means that SSL certificates are searched for in configuration directory, as specified in `node['pyload']['config_dir']`.
* `node['pyload']['ssl']['cert']` - Specifies the SSL certificate name. By default, this is set to *ssl.crt*.
* `node['pyload']['ssl']['key']` - Specifies the SSL certificate key name. By default, this is set to *ssl.key*.

### Webinterface Settings

The `node['pyload']['webinterface']` namespace defines webinterface settings for Pyload, which will be set in *pyload.conf* configuration file.

* `node['pyload']['webinterface']['activated']` - Enables or disables Pyload webinterface. By default, this is enabled, which means that this is set to *true*.
* `node['pyload']['webinterface']['server_type']` - Specifies the webinterface server type. Allowed values are `builtin`, `threaded`, `fastcgi` and `lightweight`. More information on these types can be found in Pyload documentation. By default, this is set to *builtin*.
* `node['pyload']['webinterface']['listen_address']` - Specifies the address on which the webinterface should listen on. By default, this is set to *0.0.0.0*.
* `node['pyload']['webinterface']['port']` - Specifies the port for the webinterface to connect to. By default, this is set to *8080*.
* `node['pyload']['webinterface']['template']` - Specifies the template for the webinterface. By default, this is set to *default*.
* `node['pyload']['webinterface']['prefix']` - Specifies the path where all files of the webinterface are located. By default, the webinterface files are stored in the install directory, which means that this is set to *nil*.

## Recipes

### default

This is the only recipe which should be included either in your nodes `run_list` or by using `include_recipe` in your wrapper cookbook. The recipe will create the specified user and group for pyload and includes all other recipes of this cookbook.

### config

This recipe creates the configuration directory for Pyload, as specified in `node['pyload']['conf_dir']`, creates all required folders and places all required configuration files in it.

<!-- TODO: Check if that description applies -->
### install

This recipe does a number of things to install Pyload. This includes, creating the install directory for Pyload, as specified in `node['pyload']['install_dir']` and the PID file directory, as specified in `node['pyload']['pid_dir']`. Moreover, it will clone Pyload source code from the [official Pyload Git repository](https://github.com/pyload/pyload) and checkout the *stable* branch. Next, it will perform a system check, to check if Pyload is able to run by using the [*systemCheck.py*](https://github.com/pyload/pyload/blob/stable/systemCheck.py) script. In the end it creates symbolic links to */usr/bin* for all Pyload executeables ([pyLoadCli](https://github.com/pyload/pyload/blob/stable/pyLoadCli.py), [pyLoadCore](https://github.com/pyload/pyload/blob/stable/pyLoadCore.py), [pyLoadGui](https://github.com/pyload/pyload/blob/stable/pyLoadGui.py)), to allow running Pyload directly from bash as command.

### packages

This will install all packages regarding your systems platform type, as specified in `node['pyload']['packages']`.

### service

This recipe includes one of the `pyload::INIT_STYLE_service` recipes based on the attribute `node['pyload']['init_style']`, which is set regarding your target platform. The individual service recipes can be included directly too, if required. The supported init systems are

* `init` - uses the Sys-V-Init script included in this cookbook, supported on Debian and Red Hat Enterprise Linux (RHEL) family distributions.
* `upstart` - uses the Upstart job included in this cookbook, supported on Ubuntu. *Currently this delegates to use the Sys-V-Init script!*
* `systemd` - sets up the service under SystemD. Supported on SystemD based distros.

If the init system cannot be determined by this cookbook (f.e. unsupported plattform) or any other desriptor is specified, there will be no init system script created from this cookbook.

## Tests

This cookbook uses Kitchen and Inspec for testing. For more information, see [TESTING.md](https://github.com/gridtec/cookbook-pyload/blob/master/TESTING.md).

## Frequently Asked Questions

<!-- TODO: Write a list/table of dependencies -->
### What are the dependencies of Pyload installed by this cookbook?

This cookbook installs every required and optional dependency of Pyload using the target platforms package manager. The following matrix shows all the required packages and their corresponding platform name.

| Package               | Arch                   | Debian/Ubuntu              | Fedora                | RHEL/CentOS           | Suse/OpenSuse         |
|-----------------------|------------------------|----------------------------|-----------------------|-----------------------|-----------------------|
| git                   | git                    | git                        | git                   | git                   | git                   |
| curl                  | curl                   | curl                       | curl                  | curl                  | curl                  |
| openssl               | openssl                | openssl                    | openssl               | openssl               | openssl               |
| python                | python2                | python                     | python                | python                | python                |
| python-beaker         | python2-beaker         | python-beaker              | python-beaker         | python-beaker         | python-Beaker         |
| python-beautifulsoup4 | python2-beautifulsoup4 | python-bs4                 | python-beautifulsoup4 | python-beautifulsoup4 | python-beautifulsoup4 |
| python-crypto         | python2-crypto         | python-crypto              | python-crypto (<= 23)<br/>python2-crypto (>= 24) | python-crypto (<= 6)<br/>python2-crypto (>= 7) | python-pycrypto |
| python-feedparser     | python2-feedparser     | python-feedparser          | python-feedparser     | python-feedparser     | python-feedparser     |
| python-flup           | python2-flup           | python-flup                | python-flup           | python-flup           | python-flup           |
| python-html5lib       | python2-html5lib       | python-html5lib            | python-html5lib       | python-html5lib       | python-html5lib       |
| python-imaging        | python2-pillow         | python-imaging             | python-pillow         | python-imaging (<= 6)<br/>python-pillow (>= 7) | python-imaging (<= 13.1)<br/>python-Pillow (>= 13.2) |
| python-jinja2         | python2-jinja          | python-jinja2              | python-jinja2         | python-jinja2         | python-Jinja2         |
| python-pycurl         | python2-pycurl         | python-pycurl              | python-pycurl         | python-pycurl         | python-pycurl         |
| python-pyopenssl      | python2-pyopenssl      | python-openssl             | pyOpenSSL             | pyOpenSSL             | python-pyOpenSSL      |
| python-pyqt4          | python2-pyqt4          | python-qt4                 | PyQt4                 | PyQt4                 | python-qt4            |
| python-simplejson     | python2-simplejson     | python-simplejson          | python-simplejson     | python-simplejson     | python-simplejson     |
| python-thrift         | python2-thrift         | python-thrift (>= 8/14.04) | python-thrift         | python-thrift (>=7)   | python-thrift         |
| ossp-js               | js                     | libmozjs185-1.0 (<= 7/12.04)<br/>libmozjs-24-bin (>= 8/14.04) | js | js    | js<br/>python-python-spidermonkey |
| rhino                 | rhino                  | rhino                      | rhino                 | rhino                 | rhino                 |
| tesseract             | tesseract<br/>tesseract-git<br/>tesseract-ocr-git | tesseract-ocr<br/>tesseract-ocr-eng<br/>gocr | tesseract | tesseract | tesseract |

More information can be found in the Pyloads project [README](https://github.com/pyload/pyload/blob/stable/README).

### Why does this cookbook doesn't use Python PIP to install all dependencies for Pyload?

We thought about that, but we really do not need Python packages in a virtualenv but system-wide and we definitly can use the latest version of Python packages as no specific version is needed, so we decided in the end to use the systems package manager only. We could use Python PIP by just including the [poise-python](https://github.com/poise/poise-python) cookbook, as it provides a custom resource for installing packages using pip.

If you already have Python PIP installed on your system and you really depend on using it, you may want to set the `node['pyload']['packages']` attribute to *nil* which disables package install of this cookbook completely, but this will require you to take care that each required Pyload dependency is installed.

However, in future time it might be necessary to use Python PIP to get the transparency for each platform, if we are not able to determine dependency package names for each platform anymore. Moreover, if the community wants us to install dependencies using Python PIP and that this is seen as an improvement of this cookbook, feel free to create an issue for that to let us know.

### Why is a package required for Pyload not found on RHEL and its derivatives?

On RHEL and derivatives, it is required to install 3rd party repositories as base repositories do no include every required package. Either put [yum](https://github.com/chef-cookbooks/yum) and [yum-epel](https://github.com/chef-cookbooks/yum-epel) cookbooks in your `run_list` or include them by using `include_recipe` in your wrapper cookbook.

### Does this cookbook generate a SSL certificates?

No. You need to create your own SSL certificates either in your wrapper cookbook or manually on your node and configure this cookbook where this certificates can be found on the system.

SSL certificate can be manually create by executing

```bash
  openssl genrsa 1024 > ssl.key openssl req -new -key ssl.key -out ssl.csr openssl req -days 36500 -x509 -key ssl.key -in ssl.csr > ssl.crt`
  ```

<!-- TODO: Why does this cookbook not provide an Upstart Script -->
<!-- TODO: I want to contribute. What do I need to do? look contributing md -->
<!-- TODO: I want to test. What do I need to do? Look testingmd -->

## License & Authors

<!-- TODO: Change to gridtec and set me as maintainer -->
* Author: Dominik Jessich [jessichd@gridtec.at](mailto:jessichd@gridtec.at)

```
Copyright 2016, Gridtec

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
