# Pyload Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/pyload.svg)](https://supermarket.chef.io/cookbooks/pyload)
[![Build](https://github.com/djessich/cookbook-pyload/workflows/kitchen/badge.svg)](https://github.com/djessich/cookbook-pyload/actions?query=workflow%3Akitchen)
[![Delivery](https://github.com/djessich/cookbook-pyload/workflows/delivery/badge.svg)](https://github.com/djessich/cookbook-pyload/actions?query=workflow%3Adelivery)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

This cookbook provides resources for installing and configuring [Pyload](https://github.com/pyload/pyload).

## Requirements

### Platforms

* CentOS 7+
* Debian 10+
* Fedora 32+
* Oracle 7+
* RHEL 7+
* Ubuntu 16.04+

### Chef

Chef 15+

## Dependencies

This cookbook has the following dependencies:

* [yum-epel](https://supermarket.chef.io/cookbooks/yum-epel)

## Usage

This cookbook provides various resources for installing and configuring your Pyload instance(s), which are best used in your own wrapper cookbook. Specify your own parameters on any of the provided resources, to install one or multiple Pyload instances regarding your needs.

### Resource Names

Many of the resources provided in this cookbook need to share configuration values for an instance. Therefore each resource provides a property `instance_name` to correctly identify all the resources of a single instance, which must be unique obviously. As an example, the `pyload_config` resource needs to know the version of the instance and the download directory created by `pyload_install` to correctly configure the instance.

All the resources of this cookbook use the following search order in Chefs run context to locate all the corresponding resources that apply to a unique instance:
1. Resources that share the same resource name
2. Resources that share the same value for property `instance_name`
3. Resources named either *default* or *pyload* (fails if resources with both *default* or *pyload* as name exist)
4. Resources with `instance_name` set to either *default* or *pyload* (fails if resources with both *default* or *pyload* as value for `instance_name` exist)

In case the `instance_name` of any resource is set to a value not a reserved default (*default* or *pyload*), the instance name will be appended to the resource properties default values. This is required to avoid conflicts for multi instance configurations. As an example, properties specifying a directory will have their default value automatically changed to a directory with the instance name included (`/opt/pyload` -> `/opt/pyload_INSTANCE_NAME`).

### Notifications

The resources provided in this cookbook do not automatically execute any actions on instance resources when changes have occurred. You must supply your desired notifications for an instance when using resources of this cookbook if you want Chef to automatically restart services. See below for an example how to do this.

### Examples

The following example will install a global instance of Pyload using the defaults:

```ruby
pyload_install 'default' do
  notifies :restart, 'pyload_service[default]', :delayed
end

pyload_config 'default' do
  notifies :restart, 'pyload_service[default]', :delayed
end

pyload_service 'default' do
  action [:start, :enable]
end
```

More examples on how this cookbook could be used, can be found at `test/fixtures/cookbooks/test`.

## Resources

### pyload_install

Installs an instance of Pyload regarding configured install method.

#### Actions

* `install` - Default. Installs an instance of Pyload with configured installed method.
* `install_pip` - Installs an instance of Pyload with install method `pip`. This install method requires version to be `>= 0.5.0`
* `install_source` - Installs an instance of Pyload with install method `source`. This install method requires version to be `< 0.5.0`.

#### Properties

* `instance_name` - Specifies a unique name for the instance to be installed. Reserved default instance names are `default` and `pyload`. This is the name property.
* `version` - Specifies the version to be installed. By default, this is set to `0.4.20`.
* `install_method` - Specifies the install method used to install the instance. Supported methods are `pip` and `source`. By default, this is set to `source`.
* `install_dir` - Specifies the full path to the install directory. By default, this is set to `/opt/pyload`.
* `data_dir` - Specifies the full path to the data directory. By default, this is set to `/var/lib/pyload`.
* `log_dir` - Specifies the full path to the logging directory. By default, this is set to `/var/log/pyload`.
* `download_dir` - Specifies the full path to the download directory. By default, this is set to `/tmp/downloads`.
* `tmp_dir` - Specifies the full path to the temp directory. By default, this is set to `/tmp/pyload`.
* `user` - Specifies the user to run the instance. By default, this is set to `pyload`.
* `group` - Specifies the group to run the instance. By default, this is set to `pyload`.
* `source_path` - Specifies the full path to the distribution source. If the file does not exist, it will be downloaded from `source_url`. Only used if install method is set to `source`. By default, this depends on specified version.
* `source_url` - Specifies the download URL to the distribution source. Only used if install method is set to `source`. By default, this depends on specified version.
* `source_checksum` - Specifies a checksum for the distribution source downloaded from `source_url`. Only used if install method is set to `source`. This must be a valid SHA256 hash. By default, this depends on specified version.
* `create_user` - Specifies if the user should be created. By default, this is set to `true`.
* `create_group` - Specifies if the group should be created. By default, this is set to `true`.
* `create_download_dir` - Specifies if the download directory should be created.  By default, this is set to `true`.
* `create_symlink` - Specifies if a symbolic link should be created from `install_dir` to latest version. By default, this is set to `true`.

#### Examples

Installs an Pyload 0.4.20 instance named with reserved default instance name *default*. The instance is installed to default directories using instance method `source`. It will be created at `/opt/pyload-0.4.20` with a symbolic link at `/opt/pyload`. All directories will owned by user `pyload` and group `pyload`.

```ruby
pyload_install 'default' do
  version '0.4.20'
end
```

Installs an Pyload 0.4.20 instance named *helloworld*. The instance is installed to default directories using instance method `source`. It will be created at `/opt/pyload_helloworld-0.4.20` with a symbolic link at `/opt/pyload_helloworld`. All directories will owned by user `pyload_helloworld` and group `pyload_helloworld`.

```ruby
pyload_install 'helloworld' do
  version '0.4.20'
end
```

### pyload_config

Configures an instance of Pyload. Not all properties available to this resource apply to all versions of a configuration file. Some required properties, such as the instance version, are determined by the corresponding `pyload_install` resource of this instance.

#### Actions

* `create` - Default. Configures an instance of Pyload regarding its version.

#### Properties

* `instance_name` - Specifies a unique name for the instance to be configured. Reserved default instance names are `default` and `pyload`. This is the name property.
* `source` - Specifies the config file template source. By default, this depends on the instance version.
* `cookbook` - Specifies the cookbook from which to load the config file source. By default, this is set to `pyload`.
* `auto_login` - Specifies if login should be skipped if single user. By default, this is set to `false`.
* `basic_auth` - Specifies if basic authentication should be enabled for web interface. By default, this is set to `false`.
* `change_downloads` - Specifies if owner and group of downloaded files should be changed. By default, this is set to `false`.
* `change_file` - Specifies if mode of downloaded files should be changed. By default, this is set to `false`.
* `change_group` - Specifies if group of running process should be changed. By default, this is set to `false`.
* `change_user` - Specifies if user of running process should be changed. By default, this is set to `false`.
* `checksums` - Specifies if checksums should be checked. By default, this is set to `false`.
* `chunks` - Specifies the maximum connections for one download. By default, this is set to `3`.
* `console` - Specifies if logging to console should be enabled. By default, this is set to `true`.
* `console_color` - Specifies if console log should be colored if logging to console is enabled. By default, this is set to `false`.
* `debug_level` - Specifies the debug level. Must be one of `debug`, `trace` or `stack`. By default, this is set to `trace`.
* `debug_mode` - Specifies if debug mode should be enabled. By default, this is set to `false`.
* `development_mode` - Specifies if web interface development mode should be enabled. By default, this is set to `false`.
* `end_time` - Specifies the time downloads should be stopped automatically. By default, this is set to `0:00`.
* `file_mode` - Specifies the mode for created files. By default, this is set to `0644`.
* `folder_mode` - Specifies the mode for created folders. By default, this is set to `0755`.
* `folder_per_package` - Specifies if a folder for each downloaded package should be created. By default, this is set to `true`.
* `interface` - Specifies the download interface to bind to.
* `ipv6` - Specifies if IPv6 should be enabled. By default, this is set to `false`.
* `language` - Specifies the language. Must be one of `en`, `de`, `fr`, `it`, `es`, `el_GR`, `nl`, `sv`, `ru`, `pl`, `cs`, `sr` or `pt_BR` for config version 1 and `en` for config version 2. By default, this is set to `en`.
* `limit_speed` - Specifies if download speed should be limited to maximum download speed. By default, this is set to `false`.
* `listen_address` - Specifies the listen address for the web interface. By default, this is set to `0.0.0.0`.
* `log` - Specifies if logging to files should be enabled. By default, this is set to `true`.
* `log_entries` - Specifies the maximum amount of log files to keep if logging to files is enabled. By default, this is set to `10`.
* `log_rotate` - Specifies if log files should be rotated if logging to files is enabled. By default, this is set to `true`.
* `log_size` - Specifies the maximum size of file log before the log file is rotated in KB if logging to files is enabled. By default, this is set to `100`.
* `max_downloads` - Specifies the maximum parallel downloads. By default, this is set to `3`.
* `max_speed` - Specifies the maximum download speed in KB/s. By default, this is set to `-1`.
* `min_free_space` - Specifies the minimum free space at download directory in MB. By default, this is set to `1024`.
* `port` - Specifies the port the web interface should listen on. By default, this is set to `8000`.
* `prefix` - Specifies the web interface path prefix.
* `proxy` - Specifies if a proxy should be used. By default, this is set to `false`.
* `proxy_host` - Specifies the proxy host address if proxy port should be used. By default, this is set to `localhost`.
* `proxy_password` - Specifies the password for proxy authentication if proxy should be used.
* `proxy_port` - Specifies the proxy port if proxy should be used. By default, this is set to `7070`.
* `proxy_protocol` - Specifies the proxy protocol if proxy should be used. Must be one of `http`, `socks4` or `socks5`. By default, this is set to `http`.
* `proxy_username` - Specifies the username for proxy authentication if proxy should be used.
* `reconnect` - Specifies if reconnect should be enabled. By default, this is set to `false`.
* `reconnect_end_time` - Specifies the reconnect end time if reconnect is enabled. By default, this is set to `0:00`.
* `reconnect_method` - Specifies the reconnect method if reconnect is enabled. Applies only to config version 1.
* `reconnect_script` - Specifies the reconnect script if reconnect is enabled. Applies only to config version 2.
* `reconnect_start_time` - Specifies the reconnect start time if reconnect is enabled. By default, this is set to `0:00`.
* `remote` - Specifies if remote interface should be enabled. By default, this is set to `false`.
* `remote_listen_address` - Specifies the listen address for the remote interface if remote is enabled. By default, this is set to `0.0.0.0`.
* `remote_no_local_auth` - Specifies if local connections require authentication if remote is enabled. By default, this is set to `true`.
* `remote_port` - Specifies the port the remote interface should listen on if remote is enabled. By default, this is set to `7227`.
* `renice` - Specifies the CPU priority. By default, this is set to `0`.
* `server_type` - Specifies the server type of the web interface. Must be one of `builtin`, `threaded`, `fastcgi` or `lightweight`. By default, this is set to `builtin`.
* `skip_existing` - Specifies if files previously downloaded should be skipped. By default, this is set to `false`.
* `ssl` - Specifies if web interface should be served via SSL/TLS. By default, this is set to `false`.
* `ssl_cert` - Specifies the SSL/TLS certificate.
* `ssl_chain` - Specifies the SSL/TLS certificate chain.
* `ssl_key` - Specifies the SSL/TLS  certificate key.
* `start_time` - Specifies the time downloads should be started automatically. By default, this is set to `0:00`.
* `syslog` - Specifies if logging to syslog should be enabled. By default, this is set to `false`.
* `syslog_dir` - Specifies the syslog folder to log to if syslog is enabled. Applies only to config version 2.
* `syslog_host` - Specifies the syslog host address if syslog is enabled. By default, this is set to `localhost`.
* `syslog_location` - Specifies the syslog location if syslog is enabled. ust be one of `local` or `remote`. By default, this is set to `locale`.
* `syslog_port` - Specifies the syslog host port if syslog is enabled. By default, this is set to `514`.
* `theme` - Specifies the theme of the web interface. Must be one of `classic`, `pyplex` or `modern` for version 1 and `Default` or `PyPlex` for version 2. By default, this is set to `classic` for config version 1 and `Default` for config version 2.
* `web` - Specifies if web interface should be enabled. By default, this is set to `true`.

#### Examples

Configures an Pyload 0.4.20 instance named with reserved default instance name *default* with config version 1. The corresponding resources from this cookbook for this instance with name *default*, e.g. `pyload_install[default]`, will be used for configuration. The config file for this instance will be created in data directory at `/var/lib/pyload` and configures classic theme.

```ruby
pyload_config 'default' do
  theme 'classic'
end
```

Configures an Pyload 0.4.20 instance named *helloworld* with config version 1. The corresponding resources from this cookbook for this instance with name *helloworld*, e.g. `pyload_install[helloworld]`, will be used for configuration. The config file for this instance will be created in data directory at `/var/lib/pyload_helloworld` and configures modern theme.

```ruby
pyload_config 'helloworld' do
  theme 'modern'
end
```

### pyload_service

Creates a service configuration for an instance of Pyload to run using the appropriate init system. Some required properties, such as the instance version, are determined by the corresponding `pyload_install` resource of this instance.

#### Actions

* `start` - Default. Starts the instance of Pyload.
* `stop` - Stops the instance of Pyload.
* `enable` - Enables the instance of Pyload.
* `disable` - Disables the instance of Pyload.
* `restart` - Restarts the instance of Pyload.
* `create` - Creates configuration file for the appropriate init system for the instance of Pyload. Automatically called by actions `start` and `enable`.

#### Properties

* `instance_name` - Specifies a unique name for the instance service configuration to be created. Reserved default instance names are `default` and `pyload`. This is the name property.
* `service_name` - Specifies the service name. By default, this is set to `pyload`.
* `env_vars` - Specifies a hash of environment variables to be applied. By default, this is set to an empty hash.
* `kill_signal` - Specifies the kill signal used to stop a running service. By default, this is set to `SIGINT`.
* `restart_policy` - Specifies the restart policy of a service. By default, this is set to `always`.

#### Examples

Creates a service configuration for an Pyload 0.4.20 instance named with reserved default instance name *default*. The corresponding resources from this cookbook for this instance with name *default*, e.g. `pyload_install[default]`, will be used during creation of the service configuration. The service configuration will be created with a restart policy that restarts the service on abort.

```ruby
pyload_service 'default' do
  restart_policy 'on-abort'
end
```

Creates a service configuration for an Pyload 0.4.20 instance named *helloworld*. The corresponding resources from this cookbook for this instance with name *helloworld*, e.g. `pyload_install[helloworld]`, will be used during creation of the service configuration. The service configuration will be created with a restart policy that restarts the service on abort.

```ruby
pyload_service 'helloworld' do
  restart_policy 'on-abort'
end
```

## License

* Author: Dominik Jessich ([dominik.jessich@gmail.com](mailto:dominik.jessich@gmail.com))
* Copyright: 2016-2020, Dominik Jessich

```
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
