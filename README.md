# Pyload Cookbook

This cookbook is used to install and configure [Pyload](https://github.com/pyload/pyload) on a system. It installs Pyload from Git repository, installs all required dependencies for Pyload, prepares configuration folder and files and installs the appropriate configuration for your platform's init system.

## Requirements

### Platforms

* CentOS 6+
* Debian 7+
* RHEL 6+
* Ubuntu 12.04+

*May work on other platforms too, but the cookbook is tested for the platforms above.*

### Chef

Chef 12.5+

### Cookbooks

This cookbook has no direct external dependencies.

Regarding your OS, you may need additional recipes or cookbooks for this cookbook's recipes to converge on the node. In particular, the following things should be considered.

On Debian/Ubuntu, use the [apt](https://github.com/chef-cookbooks/apt) cookbook to ensure the package cache is updated so Chef can install packages, or consider putting apt-get in your bootstrap process or knife bootstrap template. Otherwise this cookbook won't install latest versions of Pyload dependencies, to be installed by apt.

On RHEL and derivatives, some 3rd party repositories are necessary to be installed and enabaled in yum to install required dependencies for Pyload. The [yum](https://github.com/chef-cookbooks/yum) and [yum-epel](https://github.com/chef-cookbooks/yum-epel) cookbooks are therefore suggested to be in your `run_list`.

## Attributes

The attributes used by this cookbook are in the `node['pyload']` namespace which is broken up into different groups.

### General settings

* `node['pyload']['install_dir']` - Specifies the location for Pyload package itself. By default, this is set to */usr/share/pyload*.
* `node['pyload']['config_dir']` - Specifies the location for Pyload configuration folders and files. By default, this is set to */home/&lt;user&gt;/.pyload* (interpolates to */home/pyload/.pyload* if defaults are used).
* `node['pyload']['pid_dir']` - Specifies the location of the PID file for Pyload. By default, this is set to */var/run/pyload*.
* `node['pyload']['download_dir']` - Specifies the location for all Pyload downloaded files. By default, this is set to *Downloads*.
* `node['pyload']['user']` - Specifies the user which is used to run Pyload. By default, this is set to *pyload*.
* `node['pyload']['group']` - Specifies the group which is used to run Pyload. By default, this is set to *pyload*.
* `node['pyload']['dir_mode']` - Specifies the mode for all folders created by this cookbook. By default, this is set to *0755*.
* `node['pyload']['file_mode']` - Specifies the mode for all files created by this cookbook. By default, this is set to *0644*.
* `node['pyload']['init_style']` - Specifies the platforms init system type which can be either set to `init` or `systemd`. If something else is specified, no install script will be created. The correct init system type is determined by this cookbook itself, so this attribute is not required to be set. This attribute only exists to override this cookbook if this is required. By default, this is set to *nil*.
* `node['pyload']['packages']` - Specifies a list of dependencies of Pyload which are required to successfully start Pyload. The correct package names are determined by this cookbook, regarding platform family and platfom version. By default, this is set to all required dependencies for Pyload, including optional ones, which can be examined at Pyload repository or in the corresponding attribute file of this cookbook.

### General configuration file settings

* `node['pyload']['language']` - Specifies Pyload language. Allowed values are `en`, `de`, `fr`, `it`, `es`, `nl`, `sv`, `ru`, `pl`, `cs`, `sr`, `pt_BR`. If something else is specified, Pyload may not start. By default, this is set to *en*.
* `node['pyload']['debug_mode']` - Specifies if Pyload should be started in debug mode. By default, this is set to *false*.
* `node['pyload']['min_free_space']` - Specifies the minimum of free space required in the downloads location (specified in `node['pyload']['download_dir']`) in MB. By default, this is set to *200*.
* `node['pyload']['folder_per_package']` - Specifies if each download should be saved in a folder in the downloads loation (specified in `node['pyload']['download_dir']`). By default, this is set to *true*.
* `node['pyload']['cpu_priority']` - Specifies the CPU priority of the Pyload process. By default, this is set to *0*.
* `node['pyload']['use_checksum']` - Specifies if Pyload should use checksums. By default, this is set to *false*.

## Recipes

### default

TODO: Enter default recipe description here.

## Frequently Asked Questions

### What are the dependencies of Pyload installed by this cookbook?

This cookbook installs every required and optional dependency of Pyload as described in the Pyloads project [README](https://github.com/pyload/pyload/blob/stable/README) using the systems package manager.

### Why does this cookbook doesn't use Python PIP to install all dependencies for Pyload?

We thought about that, but we really do not need Python packages in a virtualenv but system-wide and we definitly can use the latest version of Python packages as no specific version is needed, so we decided in the end to use the systems package manager only. We could use Python PIP by just including the [poise-python](https://github.com/poise/poise-python) cookbook, as it provides a custom resource for installing packages using pip.

If you already have Python PIP installed on your system and you really depend on using it, you may want to set the `node['pyload']['packages']` attribute to *nil* which disables package install of this cookbook completely, but this will require you to take care that each required Pyload dependency is installed.

However, in future time it might be necessary to use Python PIP to get the transparency for each platform, if we are not able to determine dependency package names for each platform anymore. Moreover, if the community wants us to install dependencies using Python PIP and that this is seen as an improvement of this cookbook, feel free to create an issue for that to let us know.

### Why is a package required for Pyload not found on RHEL and its derivatives?

On RHEL and derivatives, it is required to install 3rd party repositories as base repositories do no include every required package. Either put [yum](https://github.com/chef-cookbooks/yum) and [yum-epel](https://github.com/chef-cookbooks/yum-epel) cookbooks in your `run_list` or include them by using `include_recipe` in your wrapper cookbook.

### Does this cookbook generate a SSL certificates?

No. You need to create your own SSL certificates either in your wrapper cookbook or manually and configure this cookbook where this certificates can be found on the system.

## License & Authors

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
