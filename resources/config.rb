#
# Cookbook:: pyload
# Resource:: config
#
# Copyright:: 2022, Dominik Jessich
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

include PyloadCookbook::Helpers

unified_mode true

property :instance_name, String, name_property: true
property :source, String
property :cookbook, String, default: 'pyload'
property :auto_login, [true, false], default: false
property :basic_auth, [true, false], default: false
property :change_downloads, [true, false], default: false
property :change_file, [true, false], default: false
property :change_group, [true, false], default: false
property :change_user, [true, false], default: false
property :checksums, [true, false], default: false
property :chunks, [String, Integer], default: 3
property :console, [true, false], default: true
property :console_color, [true, false], default: false
property :debug_level, String, equal_to: %w(debug trace stack), default: 'trace'
property :debug_mode, [true, false]
property :development_mode, [true, false], default: false
property :end_time, String, default: '0:00'
property :file_mode, String, default: '0644'
property :folder_mode, String, default: '0755'
property :folder_per_package, [true, false], default: true
property :interface, String
property :ipv6, [true, false], default: false
property :language, String, equal_to: %w(en de fr it es el_GR nl sv ru pl cs sr pt_BR), default: 'en'
property :limit_speed, [true, false], default: false
property :listen_address, String, default: '0.0.0.0'
property :log, [true, false], default: true
property :log_entries, [String, Integer], default: 10
property :log_rotate, [true, false], default: true
property :log_size, [String, Integer], default: 100
property :max_downloads, [String, Integer], default: 3
property :max_speed, [String, Integer], default: -1
property :min_free_space, [String, Integer], default: 1024
property :port, [String, Integer], default: 8000
property :prefix, String
property :proxy, [true, false], default: false
property :proxy_host, String, default: 'localhost'
property :proxy_password, String, sensitive: true
property :proxy_port, [String, Integer], default: 7070
property :proxy_protocol, [String, Integer], equal_to: %w(http socks4 socks5), default: 'http'
property :proxy_username, String
property :reconnect, [true, false], default: false
property :reconnect_end_time, String, default: '0:00'
property :reconnect_method, String
property :reconnect_script, String
property :reconnect_start_time, String, default: '0:00'
property :remote, [true, false], default: false
property :remote_listen_address, String, default: '0.0.0.0'
property :remote_no_local_auth, [true, false], default: true
property :remote_port, [String, Integer], default: 7227
property :renice, [String, Integer], default: 0
property :server_type, String, equal_to: %w(builtin threaded fastcgi lightweight), default: 'builtin'
property :session_lifetime, [String, Integer], default: 44640
property :skip_existing, [true, false], default: false
property :ssl, [true, false], default: false
property :ssl_cert, String
property :ssl_chain, String
property :ssl_key, String
property :start_time, String, default: '0:00'
property :syslog, [true, false], default: false
property :syslog_dir, String
property :syslog_host, String, default: 'localhost'
property :syslog_location, String, equal_to: %w(local remote), default: 'local'
property :syslog_port, [String, Integer], default: 514
property :theme, String, equal_to: %w(classic modern pyplex Default PyPlex)
property :web, [true, false], default: true

action :create do
  pyload_install_resource = find_pyload_install_resource!(new_resource)

  template config_path(pyload_install_resource.version, pyload_install_resource.data_dir) do
    source new_resource.source || default_pyload_config_source(pyload_install_resource.version)
    cookbook new_resource.cookbook
    owner pyload_install_resource.user
    group pyload_install_resource.group
    mode '0600'
    sensitive new_resource.sensitive
    variables(
      auto_login: python_bool_value(new_resource.auto_login),
      basic_auth: python_bool_value(new_resource.basic_auth),
      change_downloads: python_bool_value(new_resource.change_downloads),
      change_file: python_bool_value(new_resource.change_file),
      change_group: python_bool_value(new_resource.change_group),
      change_user: python_bool_value(new_resource.change_user),
      checksums: python_bool_value(new_resource.checksums),
      chunks: new_resource.chunks,
      console: python_bool_value(new_resource.console),
      console_color: python_bool_value(new_resource.console_color),
      debug_level: new_resource.debug_level,
      debug_mode: new_resource.debug_mode || python_bool_value(pyload_next?(pyload_install_resource.version)),
      development_mode: python_bool_value(new_resource.development_mode),
      download_dir: pyload_install_resource.download_dir,
      end_time: new_resource.end_time,
      file_mode: new_resource.file_mode,
      folder_mode: new_resource.folder_mode,
      folder_per_package: python_bool_value(new_resource.folder_per_package),
      group: pyload_install_resource.group,
      interface: new_resource.interface,
      ipv6: python_bool_value(new_resource.ipv6),
      language: new_resource.language,
      limit_speed: python_bool_value(new_resource.limit_speed),
      listen_address: new_resource.listen_address,
      log: python_bool_value(new_resource.log),
      log_dir: pyload_install_resource.log_dir,
      log_entries: new_resource.log_entries,
      log_rotate: python_bool_value(new_resource.log_rotate),
      log_size: new_resource.log_size,
      max_downloads: new_resource.max_downloads,
      max_speed: new_resource.max_speed,
      min_free_space: new_resource.min_free_space,
      port: new_resource.port,
      prefix: new_resource.prefix,
      proxy: python_bool_value(new_resource.proxy),
      proxy_host: new_resource.proxy_host,
      proxy_password: new_resource.proxy_password,
      proxy_port: new_resource.proxy_port,
      proxy_protocol: new_resource.proxy_protocol,
      proxy_username: new_resource.proxy_username,
      reconnect: python_bool_value(new_resource.reconnect),
      reconnect_end_time: new_resource.reconnect_end_time,
      reconnect_method: new_resource.reconnect_method,
      reconnect_script: new_resource.reconnect_script,
      reconnect_start_time: new_resource.reconnect_start_time,
      remote: python_bool_value(new_resource.remote),
      remote_listen_address: new_resource.remote_listen_address,
      remote_no_local_auth: python_bool_value(new_resource.remote_no_local_auth),
      remote_port: new_resource.remote_port,
      renice: new_resource.renice,
      server_type: new_resource.server_type,
      skip_existing: python_bool_value(new_resource.skip_existing),
      ssl: python_bool_value(new_resource.ssl),
      ssl_cert: new_resource.ssl_cert,
      ssl_chain: new_resource.ssl_chain,
      ssl_key: new_resource.ssl_key,
      start_time: new_resource.start_time,
      session_lifetime: new_resource.session_lifetime,
      syslog: python_bool_value(new_resource.syslog),
      syslog_dir: new_resource.syslog_dir,
      syslog_host: new_resource.syslog_host,
      syslog_location: new_resource.syslog_location,
      syslog_port: new_resource.syslog_port,
      theme: new_resource.theme || default_pyload_config_value_theme(pyload_install_resource.version),
      theme_changed_line: config_theme_changed_line?(pyload_install_resource.version, pyload_install_resource.data_dir),
      user: pyload_install_resource.user,
      version: config_version(pyload_install_resource.version),
      web: python_bool_value(new_resource.web)
    )
  end
end

action_class do
  # Returns the config file path for given pyload version.
  def config_path(version, data_dir)
    if pyload_next?(version)
      "#{data_dir}/settings/pyload.cfg"
    else
      "#{data_dir}/pyload.conf"
    end
  end

  # Returns the config version for specified pyload version.
  def config_version(version)
    v = pyload_next?(version) ? 2 : 1
    "#{v} "
  end

  # Checks if the line specifying the theme in Pyload configuration file is of
  # changed format.
  # See: https://github.com/pyload/pyload/issues/3841
  def config_theme_changed_line?(version, data_dir)
    config_file = config_path(version, data_dir)
    return false unless ::File.exist?(config_file)
    result = ::File.readlines(config_file).grep(/classic;modern;pyplex/)
    !result.empty?
  end

  # Transforms the given boolean value to its python equivalent.
  def python_bool_value(value)
    value ? 'True' : 'False'
  end
end
