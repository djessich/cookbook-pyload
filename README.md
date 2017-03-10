# Pyload Cookbook

[![Build Status](https://travis-ci.org/gridtec/cookbook-pyload.svg?branch=master)](https://travis-ci.org/gridtec/cookbook-pyload)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![Cookbook Version](https://img.shields.io/cookbook/v/pyload.svg)](https://supermarket.chef.io/cookbooks/pyload)

This cookbook is used to install and configure [Pyload](https://github.com/pyload/pyload) on a system. Just put it in your nodes `run_list` or include the default recipe using `include_recipe`. This cookbook installs Pyload from its Git repository regarding the version tag or branch you've configured, installs all required dependencies for Pyload, prepares configuration folder and files and installs the appropriate configuration for your platform's init system.

## Requirements

### Platforms

* ArchLinux
* CentOS 6+
* Debian 7+
* Fedora 22+
* FreeBSD 10+
* openSUSE 13+
* RHEL 6+
* Ubuntu 12.04+

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

* `node['pyload']['version']` - Specifies the version to install. By default, this is set to *stable*.
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
* `node['pyload']['packages']` - Specifies a list of dependencies of Pyload which are required to successfully start Pyload. The correct package names are determined by this cookbook, regarding platform and platfom version. By default, this is set to all required dependencies for Pyload, including optional ones, which can be examined at Pyload repository or in the corresponding attribute file of this cookbook.
* `node['pyload']['accounts']` - Specifies all accounts to be configured for Pyload. The value is expected to be a hash which includes one or multiple ids representing an account whereas each id has a subhash as value representing the account data. The subhash should have the following content:
  * `user` - The name of the user which identifies the account. Required.
  * `password` - The password of the user which identifies the account. Required.
  * `name` - The name for the account. If unset, the account id will be used, so this is optional.

  The following example demonstrates the use of this attribute:
  ```ruby
    accounts = {
      ftp: {
        user: 'root',
        password: 'changeme',
        name: 'Ftp'
      }
    }
  ```

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

The `node['pyload']['log']` namespace defines logging settings for Pyload, which will be set in *pyload.conf* configuration file.

* `node['pyload']['log']['activated']` - Enables or disables logging. By default, this is enabled, which means that this is set to *true*.
* `node['pyload']['log']['count']` - Specifies the maximum allowed logging files to keep, until they get deleted. By default, this is set to *5*.
* `node['pyload']['log']['size']` - Specifies the maximum size of the log files in KB. By default, this is set to *100*.
* `node['pyload']['log']['rotate']` - Specifies if logfiles should be rotated. This means, that the standard log file name represents the last logging output. By default, this is enabled, which means, that this is set to *true*.

### Permission Settings

The `node['pyload']['permission']` namespace defines permissive settings for Pyload, which will be set in *pyload.conf* configuration file.

* `node['pyload']['permission']['user']` - Specifies the username which will be used by Pyload. If set to *nil*, the value specified in `node['pyload']['user']` will be used. By default, this is set to *nil*.
* `node['pyload']['permission']['group']` - Specifies the groupname which will be used by Pyload. If set to *nil*, the value specified in `node['pyload']['group']` will be used. By default, this is set to *nil*.
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

This is the only recipe which should be included either in your nodes `run_list` or by using `include_recipe` in your wrapper cookbook. The recipe will create the specified user and group for pyload and includes all other recipes of this cookbook (see below).

### config

This recipe sets up the config directory as specified in `node['pyload']['conf_dir']` which includes creating the required folders and placing necessary configuration files.

### install

This recipe does a number of things to install Pyload. This includes the following

* create the install directory as specified in `node['pyload']['install_dir']`
* create the configuration directory as specified in `node['pyload']['conf_dir']`
* create the download directory as specified in `node['pyload']['download_dir']`
* create the pid file directory (run directory) as specified in `node['pyload']['pid_dir']`
* create the logging directory as specified in `node['pyload']['log_dir']`
* clone Pyload source code from the [official Pyload Git repository](https://github.com/pyload/pyload) and checkout the version tag or branch (default will be the latest *stable* branch)
* perform a system check, to check if Pyload is able to run by using the [*systemCheck.py*](https://github.com/pyload/pyload/blob/stable/systemCheck.py) script in the source code
* create symbolic links to */usr/bin* for all Pyload executeables ([pyLoadCli](https://github.com/pyload/pyload/blob/stable/pyLoadCli.py), [pyLoadCore](https://github.com/pyload/pyload/blob/stable/pyLoadCore.py), [pyLoadGui](https://github.com/pyload/pyload/blob/stable/pyLoadGui.py)), to allow running Pyload directly from bash as command

#### Note for OpenSUSE and derivatives:

On OpenSUSE and derivatives, the install recipe will need to execute a fix for starting Pyload as it fails to start due to overwritten `find` function. This fix will remove the line `translation.func_globals['find'] = find` from file `node['pyload']['install_dir']/module/common/pylgettext.py` by commenting it out. See issue [#2755](https://github.com/pyload/pyload/issues/2577) of Pyload repository.

If you encounter issues in Pyload functionality because of this fix, you can uncomment the commented line `translation.func_globals['find'] = find` from file `node['pyload']['install_dir']/module/common/pylgettext.py` and disable the execution of the fix in this cookbook. This can be done by overwriting the attribute `node['pyload']['use_fix']` with value *false* (by default *true*).

### packages

This will install all packages regarding your systems platform type, as specified in `node['pyload']['packages']`.

### service

This recipe includes one of the `pyload::INIT_STYLE_service` recipes based on the attribute `node['pyload']['init_style']`, which is set regarding your target platform. The individual service recipes can be included directly too, if required. The supported init systems are

* `bsd` - uses the rc.d init script included in this cookbook, supported on FreeBSD only.
* `init` - uses the Sys-V-Init script included in this cookbook, supported on Debian and Red Hat Enterprise Linux (RHEL) family distributions.
* `upstart` - uses the Upstart job included in this cookbook, supported on Ubuntu. *Currently this delegates to use the Sys-V-Init script!*
* `systemd` - sets up the service under SystemD. Supported on SystemD based distros.

If the init system cannot be determined by this cookbook (f.e. unsupported platform) or any other desriptor is specified, there will be no init system script created from this cookbook.

## Usage

Using this cookbook is relatively straight forward. Either put the default recipe (`pyload::default`) in a nodes `run_list` or include it in a your wrapper cookbook using `include_recipe`. Change the attributes as you need them, but in most cases no change will be required.

## Development

Please see the [Contributing](https://github.com/gridtec/cookbook-pyload/blob/master/CONTRIBUTING.md) and [Testing](https://github.com/gridtec/cookbook-pyload/blob/master/TESTING.md) Guidelines.

## Frequently Asked Questions

### Which Pyload versions are able to be installed by this cookbook?

You are able to install any Pyload version which is available in the [official Pyload Git repository](https://github.com/pyload/pyload). You will just need to specify the appropriate version in `node['pyload']['version']` attribute. You are also able to install latest *stable* branch version, using `stable` identifier, which is set as default.

### What packages are installed by this cookbook?

This cookbook will install various packages during its execution by using the target platforms package manager. Thereby lots of these packages represent required and optional dependencies of Pyload. They are defined in `node['pyload']['packages']` attribute and will be determined by this cookbook on its own as there may be differences in package names on various target platforms. To illustrate this differences, we provide the following matrix to give a short overview of these different package names.

| Package           | Arch                   | Debian/Ubuntu              | Fedora                | RHEL/CentOS           | SUSE/openSUSE         | FreeBSD            |
|-------------------|------------------------|----------------------------|-----------------------|-----------------------|-----------------------|--------------------|
| git               | git                    | git                        | git                   | git                   | git                   | git                |
| curl              | curl                   | curl                       | curl                  | curl                  | curl                  | curl               |
| openssl           | openssl                | openssl                    | openssl               | openssl               | openssl               | openssl            |
| python            | python2                | python                     | python                | python                | python                | python27           |
| beaker            | python2-beaker         | python-beaker              | python-beaker         | python-beaker         | python-Beaker         | py27-beaker        |
| BeautifulSoup4    | python2-beautifulsoup4 | python-bs4                 | python-beautifulsoup4 | python-beautifulsoup4 | python-beautifulsoup4 | py27-beautifulsoup |
| pycrypto          | python2-crypto         | python-crypto              | python-crypto (<= 23)<br/>python2-crypto (>= 24) | python-crypto (<= 6)<br/>python2-crypto (>= 7) | python-pycrypto | py27-pycrypto |
| python-django     | python2-django         | python-django              | python-django (<= 23)<br/>python2-django (>= 24) | Django(<= 6)<br/>python-django (>= 7) | python-django | py27-django19
| python-feedparser | python2-feedparser     | python-feedparser          | python-feedparser     | python-feedparser     | python-feedparser     | py27-feedparser    |
| python-flup       | python2-flup           | python-flup                | python-flup           | python-flup           | python-flup           | py27-flup          |
| python-html5lib   | python2-html5lib       | python-html5lib            | python-html5lib       | python-html5lib       | python-html5lib       | py27-html5lib      |
| python-imaging    | python2-pillow         | python-imaging             | python-pillow (<= 24)<br/>python2-pillow (>= 25) | python-imaging (<= 6)<br/>python-pillow (>= 7) | python-imaging (<= 13.1)<br/>python-Pillow (>= 13.2) | py27-pillow |
| jinja2            | python2-jinja          | python-jinja2              | python-jinja2 (<= 23)<br/>python2-jinja2 (>= 24) | python-jinja2 | python-Jinja2 | py27-Jinja2 |
| pycurl            | python2-pycurl         | python-pycurl              | python-pycurl         | python-pycurl         | python-pycurl         | py27-pycurl        |
| pyOpenSSL         | python2-pyopenssl      | python-openssl             | pyOpenSSL             | pyOpenSSL             | python-pyOpenSSL      | py27-openssl       |
| pyqt4             | python2-pyqt4          | python-qt4                 | PyQt4                 | PyQt4                 | python-qt4            | py27-qt4           |
| simplejson        | python2-simplejson     | python-simplejson          | python-simplejson (<= 24)<br/>python2-simplejson (>= 25) | python-simplejson (<= 6)<br/>python2-simplejson (>= 7) | python-simplejson     | py27-simplejson    |
| thrift            | python2-thrift         | python-thrift (>= 8/14.04) | python-thrift         | python-thrift (>=7)   | python-thrift         | py27-thrift        |
| ossp-js           | js                     | libmozjs185-1.0 (<= 7/12.04)<br/>libmozjs-24-bin (>= 8/14.04) | js | js    | js<br/>python-python-spidermonkey | spidermonkey24 |
| rhino             | rhino                  | rhino                      | rhino                 | rhino                 | rhino                 | rhino              |
| tesseract         | tesseract<br/>tesseract-git<br/>tesseract-ocr-git<br/>gocr | tesseract-ocr<br/>tesseract-ocr-eng<br/>gocr | tesseract<br/>gocr | tesseract | tesseract<br/>gocr | tesseract<br/>tesseract-data<br/>gocr |
| sqlite3           |                        |                            |                       |                       |                       | py27-sqlite3       |

More information on required and optional dependencies of Pyload can be found in the official Pyloads project [README](https://github.com/pyload/pyload/blob/stable/README).

### How is this cookbook used without the Chef Server, f.e. to just install Pyload on the system?

To execute this cookbook without the Chef Server, you could use Chef Client local mode. First install the [latest Chef Client version](https://downloads.chef.io/chef) for your platform. Next clone the latest release from this cookbooks Git repository and copy it to the folder `cookbooks/pyload`. This is the directory layout required by the Chef Client. Last but not least, execute the following command, to install Pyload with Chef using the following command.

```bash
sudo chef-client -z -o pyload
```

Thats it, the cookbook should now be executed by the Chef Client. After it has been successfully finished, Pyload should be installed on your system.

### Why does this cookbook doesn't use Python PIP to install all dependencies for Pyload?

We thought about that, but we really do not need Python packages in a virtualenv but system-wide and we definitly can use the latest version of Python packages as no specific version is needed, so we decided in the end to use the systems package manager only. We could use Python PIP by just including the [poise-python](https://github.com/poise/poise-python) cookbook, as it provides a custom resource for installing packages using pip.

If you already have Python PIP installed on your system and you really depend on using it, you may want to set the `node['pyload']['packages']` attribute to *nil* which disables package install of this cookbook completely, but this will require you to take care that each required Pyload dependency is installed.

However, in future time it might be necessary to use Python PIP to get the transparency for each platform, if we are not able to determine dependency package names for each platform anymore. Moreover, if the community wants us to install dependencies using Python PIP and that this is seen as an improvement of this cookbook, feel free to create an issue for that to let us know.

### Why is a package installed by this cookbook not found on RHEL and its derivatives?

On RHEL and derivatives, it is required to install 3rd party repositories as base repositories do no include every required package. Either put [yum](https://github.com/chef-cookbooks/yum) and [yum-epel](https://github.com/chef-cookbooks/yum-epel) cookbooks in your `run_list` or include them by using `include_recipe` in your wrapper cookbook.

### Why does this cookbook does not provide an Upstart config on Upstart enabled platforms?

We are currently working on an Upstart configuration file for Pyload. As this was not working well in the first place, we decided to just use the well-developed and working Sys-V-Init script on Upstart enabled platforms. In future releases, we may be able to include an Upstart configuration file in this cookbook.

### Why are there no unpacking software installed by the cookbook, such as `unzip` or `unrar`?

We do not install unpacking software such as `unzip` or `unrar`, because on many platforms these are non-free. If you depend on using ist, please install it manually using your platforms package manager. On some platforms, such as RHEL and derivatives, it may be required to add extra repositories to allow the platforms package manager to find it.

### Does this cookbook generate a SSL certificates for me?

No. This is not the intend of this cookbook. You need to create your own SSL certificates either in your wrapper cookbook or manually on your node and configure this cookbook where this certificates can be found on the system.

SSL certificate can be manually created for example by executing

```bash
  openssl genrsa 1024 > ssl.key openssl req -new -key ssl.key -out ssl.csr openssl req -days 36500 -x509 -key ssl.key -in ssl.csr > ssl.crt
```

### I want to execute this cookbooks tests. What do I need to do?

We have provided a file called [TESTING.md](https://github.com/gridtec/cookbook-pyload/blob/master/TESTING.md) where you can find information on how to test this cookbook. We also suggest, that you have a look at [Travis CI](https://travis-ci.org/gridtec/cookbook-pyload), to see all tests we are currently executing to test this cookbook.

### I want to contribute. What do I need to do?

Thank you, that you want to help us out. Please see [CONTRIBUTING.md](https://github.com/gridtec/cookbook-pyload/blob/master/CONTRIBUTING.md) for more information on contributing to this project.

## License & Authors

* Author:: [Gridtec](http://www.gridtec.at/) ([projects@gridtec.at](mailto:projects@gridtec.at))

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

<!---
## TODO
* move the global namespace (not cookbook specific) to an own namespace
* possibily to configure each plugin
* extensions from git should be automatically added
* add ssl_certificate cookbook to manage certificates
* attribute cert_path is not required; remove and only specify absolute paths to cert_crt and cert_key
--->
