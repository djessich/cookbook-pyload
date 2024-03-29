#
# Cookbook:: pyload
# Test:: pip/default_spec
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

case os.family
when 'debian'
  packages = %w(python3 python3-dev python3-venv tar unzip curl libcurl4-openssl-dev openssl libssl-dev sqlite3 tesseract-ocr tesseract-ocr-eng)
when 'fedora'
  packages = %w(python3 python3-devel tar unzip curl libcurl-devel openssl openssl-devel sqlite tesseract)
when 'redhat'
  packages = if os.release.to_i == 8
               %w(python36 python36-devel tar unzip curl libcurl-devel openssl openssl-devel sqlite tesseract)
             else
               %w(python3 python3-devel tar unzip curl libcurl-devel openssl openssl-devel sqlite tesseract)
             end
when 'suse'
  packages = %w(python3 python3-devel tar unzip curl libcurl-devel openssl libopenssl-devel sqlite3 tesseract-ocr)
end

packages.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe user('pyload') do
  it { should exist }
  its('group') { should eq 'pyload' }
  its('groups') { should eq %w(pyload) }
  its('shell') { should eq '/bin/false' }
  its('home') { should eq '/var/lib/pyload' }
end

describe group('pyload') do
  it { should exist }
end

describe etc_group do
  its('gids') { should_not contain_duplicates }
  its('groups') { should include 'pyload' }
end

describe etc_group.where(name: 'pyload') do
  its('users') { should eq [] }
end

describe file('/opt/pyload-0.5.0b3.dev29') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload') do
  it { should exist }
  it { should be_symlink }
  its('link_path') { should eq '/opt/pyload-0.5.0b3.dev29' }
end

describe file('/opt/pyload/bin/activate') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
end

describe file('/opt/pyload/bin/python') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload/bin/python3') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload/bin/pip') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload/bin/pip3') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

%w(
  Babel beautifulsoup4 bitmath cheroot colorlog cryptography filetype Flask
  Flask-Babel Flask-Caching Flask-Compress Flask-Session Flask-Themes2 Jinja2
  Js2Py Pillow pycryptodomex pycurl pyOpenSSL pyxmpp2 semver slixmpp Send2Trash
).each do |pip_pkg|
  describe command("/opt/pyload/bin/pip show #{pip_pkg}") do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/Name\:\s#{pip_pkg}/) }
    its('stdout') { should match(%r{Location\:\s/opt/pyload\-0\.5\.0b3\.dev29/lib(?:64)?/python3\.\d\d?/site\-packages}) }
  end
end

describe file('/opt/pyload/dist') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload/dist/LICENSE.md') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should cmp '0644' }
end

describe file('/opt/pyload/bin/pyload') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/var/lib/pyload') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should cmp '0755' }
end

describe file('/var/lib/pyload/data') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should cmp '0755' }
end

describe file('/var/lib/pyload/plugins') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should cmp '0755' }
end

describe file('/var/lib/pyload/scripts') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should cmp '0755' }
end

describe file('/var/lib/pyload/settings') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should cmp '0755' }
end

describe file('/var/log/pyload') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should cmp '0755' }
end

describe file('/tmp/downloads') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should cmp '0755' }
end

describe file('/tmp/pyload') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should cmp '0755' }
end

describe file('/var/lib/pyload/settings/accounts.cfg') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should cmp '0600' }
end

describe file('/var/lib/pyload/settings/plugins.cfg') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should cmp '0600' }
end

describe file('/var/lib/pyload/settings/pyload.cfg') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'pyload' }
  its('group') { should eq 'pyload' }
  its('mode') { should cmp '0600' }
  its('content') { should match(/version\:\s2\s/) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*int\schunks\s\:\s"Maximum\sconnections\sfor\sone\sdownload"\s\=\s3}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*time\send_time\s\:\s"End\stime"\s\=\s0\:00}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*ip\sinterface\s:\s"Download\sinterface\sto\sbind\s\(IP\sAddress\)"\s\=\s}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\sipv6\s\:\s"Allow\sIPv6"\s=\sFalse}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\slimit_speed\s:\s"Limit\sdownload\sspeed"\s\=\sFalse}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*int\smax_downloads\s:\s"Maximum\sparallel\sdownloads"\s\=\s3}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*int\smax_speed\s:\s"Maximum\sdownload\sspeed\sin\sKiB/s"\s\=\s-1}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\sskip_existing\s:\s"Skip\salready\sexisting\sfiles"\s\=\sFalse}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*time\sstart_time\s:\s"Start\stime"\s\=\s0\:00}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*debug;trace;stack\sdebug_level\s:\s"Debug\slevel"\s\=\strace}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\sdebug_mode\s:\s"Debug\smode"\s\=\sTrue}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\sfolder_per_package\s:\s"Create\sfolder\sfor\seach\spackage"\s\=\sTrue}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*en;\slanguage\s:\s"Language"\s\=\sen}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*int\smin_free_space\s:\s"Minimum\sfree\sspace\sin\sMiB"\s\=\s1024}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*folder\sstorage_folder\s:\s"Download\sfolder"\s\=\s/tmp/downloads}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\sconsole\s:\s"Print\slog\sto\sconsole"\s\=\sTrue}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\sconsole_color\s:\s"Colorize\sconsole"\s\=\sFalse}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\sfilelog\s:\s"Save\slog\sto\sfile"\s\=\sTrue}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*int\sfilelog_entries\s:\s"Maximum\slog\sfiles"\s\=\s10}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*folder\sfilelog_folder\s:\s"Log\sfile\sfolder"\s\=\s/var/log/pyload}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\sfilelog_rotate\s:\s"Log\srotate"\s\=\sTrue}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*int\sfilelog_size\s:\s"Maximum\sfile\ssize\s\(in\sKiB\)"\s\=\s100}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\ssyslog\s:\s"Sent\slog\sto\ssyslog"\s\=\sFalse}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*folder\ssyslog_folder\s:\s"Syslog\slocal\sfolder"\s\=\s}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*ip\ssyslog_host\s:\s"Syslog\sremote\sIP\saddress"\s\=\slocalhost}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*local;remote\ssyslog_location\s:\s"Syslog\slocation"\s\=\slocal}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*int\ssyslog_port\s:\s"Syslog\sremote\sport"\s\=\s514}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\schange_dl\s:\s"Change\sownership\sof\sdownloads"\s\=\sFalse}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\schange_file\s:\s"Change\spermissions\sof\sdownloads"\s\=\sFalse}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\schange_group\s:\s"Change\sgroup\sof\srunning\sprocess"\s\=\sFalse}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\schange_user\s:\s"Change\suser\sof\srunning\sprocess"\s\=\sFalse}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*str\sfile\s:\s"Permission\smode\sfor\sdownloaded\sfiles"\s\=\s0644}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*str\sfolder\s:\s"Permission\smode\sfor\screated\sfolders"\s\=\s0755}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*str\sgroup\s:\s"Groupname\sfor\sownership"\s\=\spyload}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*str\suser\s:\s"Username\sfor\sownership"\s\=\spyload}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\senabled\s:\s"Activated"\s\=\sFalse}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*ip\shost\s:\s"IP\saddress"\s\=\slocalhost}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*password\spassword\s:\s"Password"\s\=\s}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*int\sport\s:\s"Port"\s\=\s7070}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*http;https,socks4;socks5\stype\s:\s"Protocol"\s\=\shttp}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*str\susername\s:\s"Username"\s\=\s}) }
  its('content') { should match(%r{reconnect\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\senabled\s:\s"Activated"\s\=\sFalse}) }
  its('content') { should match(%r{reconnect\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*time\send_time\s:\s"End\stime"\s\=\s0\:00}) }
  its('content') { should match(%r{reconnect\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*str\sscript\s:\s"Script"\s\=\s}) }
  its('content') { should match(%r{reconnect\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*time\sstart_time\s:\s"Start\stime"\s\=\s0\:00}) }
  its('content') { should match(%r{webui\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\sautologin\s:\s"Skip\slogin\sif\ssingle\suser"\s\=\sFalse}) }
  its('content') { should match(%r{webui\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\sdevelop\s:\s"Development\smode"\s\=\sFalse}) }
  its('content') { should match(%r{webui\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\senabled\s:\s"Activated"\s\=\sTrue}) }
  its('content') { should match(%r{webui\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*ip\shost\s:\s"IP\saddress"\s\=\s0\.0\.0\.0}) }
  its('content') { should match(%r{webui\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*int\sport\s:\s"Port"\s\=\s8000}) }
  its('content') { should match(%r{webui\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*str\sprefix\s:\s"Path\sprefix"\s\=\s}) }
  its('content') { should match(%r{webui\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*int\ssession_lifetime\s:\s"Session\slifetime\s\(minutes\)"\s\=\s44640}) }
  its('content') { should match(%r{webui\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*file\sssl_certchain\s:\s"CA's\sintermediate\scertificate\sbundle\s\(optional\)"\s\=\s}) }
  its('content') { should match(%r{webui\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*file\sssl_certfile\s:\s"SSL\sCertificate"\s\=\s}) }
  its('content') { should match(%r{webui\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*file\sssl_keyfile\s:\s"SSL\sKey"\s\=\s}) }
  its('content') { should match(%r{webui\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*Default;modern;pyplex\stheme\s:\s"Theme"\s\=\sDefault}) }
  its('content') { should match(%r{webui\s[a-zA-Z0-9\-\.\,"\:;_='\(\)/\n\s]*bool\suse_ssl\s:\s"Use\sHTTPS"\s\=\sFalse}) }
end

describe service('pyload') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/systemd/system/pyload.service') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
  its('content') { should match(%r{/opt/pyload/bin/python /opt/pyload/bin/pyload --userdir /var/lib/pyload --storagedir /tmp/downloads --tempdir /tmp/pyload}) }
end

describe processes('pyload') do
  it { should exist }
end
