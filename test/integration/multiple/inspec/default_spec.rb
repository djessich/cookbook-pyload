#
# Cookbook:: pyload
# Test:: multiple/default_spec
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
  packages = if os.name == 'debian' && os.release >= '11' || os.name == 'ubuntu' && os.release == '20.04'
               %w(python-is-python2 python-dev-is-python2 virtualenv tar unzip curl libcurl4-openssl-dev openssl libssl-dev sqlite3 tesseract-ocr tesseract-ocr-eng)
             else
               %w(python python-dev virtualenv tar unzip curl libcurl4-openssl-dev openssl libssl-dev sqlite3 tesseract-ocr tesseract-ocr-eng)
             end
when 'fedora'
  packages = %w(python2.7 python3-virtualenv tar unzip curl libcurl-devel openssl openssl-devel sqlite tesseract)
when 'redhat'
  packages = if os.release.to_i >= 8
               %w(python2 python2-devel python3-virtualenv tar unzip curl libcurl-devel openssl openssl-devel sqlite tesseract)
             else
               %w(python python-devel python-virtualenv tar unzip curl libcurl-devel openssl openssl-devel sqlite tesseract)
             end
when 'suse'
  packages = %w(python python-devel python2-virtualenv tar unzip curl libcurl-devel openssl libopenssl-devel sqlite3 tesseract-ocr)
end

packages.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe user('pyload_instance1') do
  it { should exist }
  its('group') { should eq 'pyload_instance1' }
  its('groups') { should eq %w(pyload_instance1) }
  its('shell') { should eq '/bin/false' }
  its('home') { should eq '/var/lib/pyload_instance1' }
end

describe group('pyload_instance1') do
  it { should exist }
end

describe user('pyload_instance2') do
  it { should exist }
  its('group') { should eq 'pyload_instance2' }
  its('groups') { should eq %w(pyload_instance2) }
  its('shell') { should eq '/bin/false' }
  its('home') { should eq '/var/lib/pyload_instance2' }
end

describe group('pyload_instance2') do
  it { should exist }
end

describe user('pyload') do
  it { should_not exist }
end

describe group('pyload') do
  it { should_not exist }
end

describe etc_group do
  its('gids') { should_not contain_duplicates }
  its('groups') { should include 'pyload_instance1' }
  its('groups') { should include 'pyload_instance2' }
  its('groups') { should_not include 'pyload' }
end

describe etc_group.where(name: 'pyload_instance1') do
  its('users') { should eq [] }
end

describe etc_group.where(name: 'pyload_instance2') do
  its('users') { should eq [] }
end

describe file('/opt/pyload_instance1-0.4.20') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload_instance1') do
  it { should exist }
  it { should be_symlink }
  its('link_path') { should eq '/opt/pyload_instance1-0.4.20' }
end

describe file('/opt/pyload_instance1/bin/activate') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
end

describe file('/opt/pyload_instance1/bin/python') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload_instance1/bin/python2') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload_instance1/bin/pip') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload_instance1/bin/pip2') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload_instance2-0.4.20') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload_instance2') do
  it { should exist }
  it { should be_symlink }
  its('link_path') { should eq '/opt/pyload_instance2-0.4.20' }
end

describe file('/opt/pyload_instance2/bin/activate') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
end

describe file('/opt/pyload_instance2/bin/python') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload_instance2/bin/python2') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload_instance2/bin/pip') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload_instance2/bin/pip2') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
end

%w(
  Beaker beautifulsoup4 feedparser flup html5lib Jinja2 Js2Py Pillow pycrypto
  pycurl pyOpenSSL pytesseract thrift
).each do |pip_pkg|
  describe command("/opt/pyload_instance1/bin/pip show #{pip_pkg}") do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/Name\:\s#{pip_pkg}/) }
    its('stdout') { should match(%r{Location\:\s/opt/pyload_instance1\-0\.4\.20/lib(?:64)?/python2\.\d\d?/site\-packages}) }
  end

  describe command("/opt/pyload_instance2/bin/pip show #{pip_pkg}") do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/Name\:\s#{pip_pkg}/) }
    its('stdout') { should match(%r{Location\:\s/opt/pyload_instance2\-0\.4\.20/lib(?:64)?/python2\.\d\d?/site\-packages}) }
  end
end

describe file('/opt/pyload_instance1/dist') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload_instance1' }
  its('group') { should eq 'pyload_instance1' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload_instance2/dist') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload_instance2' }
  its('group') { should eq 'pyload_instance2' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/pyload_instance1/dist/LICENSE.MD') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'pyload_instance1' }
  its('group') { should eq 'pyload_instance1' }
  its('mode') { should cmp '0664' }
end

describe file('/opt/pyload_instance2/dist/LICENSE.MD') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'pyload_instance2' }
  its('group') { should eq 'pyload_instance2' }
  its('mode') { should cmp '0664' }
end

describe file('/opt/pyload_instance1/bin/pyLoadCli') do
  it { should exist }
  it { should be_symlink }
  its('link_path') { should eq '/opt/pyload_instance1-0.4.20/dist/pyLoadCli.py' }
end

describe file('/opt/pyload_instance1/bin/pyLoadCore') do
  it { should exist }
  it { should be_symlink }
  its('link_path') { should eq '/opt/pyload_instance1-0.4.20/dist/pyLoadCore.py' }
end

describe file('/opt/pyload_instance1/bin/pyLoadGui') do
  it { should exist }
  it { should be_symlink }
  its('link_path') { should eq '/opt/pyload_instance1-0.4.20/dist/pyLoadGui.py' }
end

describe file('/opt/pyload_instance2/bin/pyLoadCli') do
  it { should exist }
  it { should be_symlink }
  its('link_path') { should eq '/opt/pyload_instance2-0.4.20/dist/pyLoadCli.py' }
end

describe file('/opt/pyload_instance2/bin/pyLoadCore') do
  it { should exist }
  it { should be_symlink }
  its('link_path') { should eq '/opt/pyload_instance2-0.4.20/dist/pyLoadCore.py' }
end

describe file('/opt/pyload_instance2/bin/pyLoadGui') do
  it { should exist }
  it { should be_symlink }
  its('link_path') { should eq '/opt/pyload_instance2-0.4.20/dist/pyLoadGui.py' }
end

describe file('/var/lib/pyload_instance1') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload_instance1' }
  its('group') { should eq 'pyload_instance1' }
  its('mode') { should cmp '0755' }
end

describe file('/var/lib/pyload_instance2') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload_instance2' }
  its('group') { should eq 'pyload_instance2' }
  its('mode') { should cmp '0755' }
end

describe file('/var/log/pyload_instance1') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload_instance1' }
  its('group') { should eq 'pyload_instance1' }
  its('mode') { should cmp '0755' }
end

describe file('/var/log/pyload_instance2') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload_instance2' }
  its('group') { should eq 'pyload_instance2' }
  its('mode') { should cmp '0755' }
end

describe file('/tmp/downloads_instance1') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload_instance1' }
  its('group') { should eq 'pyload_instance1' }
  its('mode') { should cmp '0755' }
end

describe file('/tmp/downloads_instance2') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'pyload_instance2' }
  its('group') { should eq 'pyload_instance2' }
  its('mode') { should cmp '0755' }
end

describe file('/var/lib/pyload_instance1/accounts.conf') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'pyload_instance1' }
  its('group') { should eq 'pyload_instance1' }
  its('mode') { should cmp '0600' }
end

describe file('/var/lib/pyload_instance2/accounts.conf') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'pyload_instance2' }
  its('group') { should eq 'pyload_instance2' }
  its('mode') { should cmp '0600' }
end

describe file('/var/lib/pyload_instance1/plugin.conf') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'pyload_instance1' }
  its('group') { should eq 'pyload_instance1' }
  its('mode') { should cmp '0600' }
end

describe file('/var/lib/pyload_instance2/plugin.conf') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'pyload_instance2' }
  its('group') { should eq 'pyload_instance2' }
  its('mode') { should cmp '0600' }
end

describe file('/var/lib/pyload_instance1/pyload.conf') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'pyload_instance1' }
  its('group') { should eq 'pyload_instance1' }
  its('mode') { should cmp '0600' }
  its('content') { should match(/version\:\s1\s/) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\schunks\s\:\s"Max\sconnections\sfor\sone\sdownload"\s\=\s3}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\sinterface\s:\s"Download\sinterface\sto\sbind\s\(ip\sor\sName\)"\s\=\s}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sipv6\s\:\s"Allow\sIPv6"\s=\sFalse}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\slimit_speed\s:\s"Limit\sDownload\sSpeed"\s\=\sFalse}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\smax_downloads\s:\s"Max\sParallel\sDownloads"\s\=\s3}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\smax_speed\s:\s"Max\sDownload\sSpeed\sin\skb/s"\s\=\s-1}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sskip_existing\s:\s"Skip\salready\sexisting\sfiles"\s\=\sFalse}) }
  its('content') { should match(%r{downloadTime\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*time\send\s\:\s"End"\s\=\s0\:00}) }
  its('content') { should match(%r{downloadTime\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*time\sstart\s:\s"Start"\s\=\s0\:00}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\schecksum\s:\s"Use\sChecksum"\s\=\sFalse}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sdebug_mode\s:\s"Debug\sMode"\s\=\sFalse}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*folder\sdownload_folder\s:\s"Download\sFolder"\s\=\s/tmp/downloads_instance1}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sfolder_per_package\s:\s"Create\sfolder\sfor\seach\spackage"\s\=\sTrue}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*en;de;fr;it;es;nl;sv;ru;pl;cs;sr;pt_BR\slanguage\s:\s"Language"\s\=\sen}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\smin_free_space\s:\s"Min\sFree\sSpace\s\(MB\)"\s\=\s1024}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\srenice\s:\s"CPU\sPriority"\s\=\s0}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sfile_log\s:\s"File\sLog"\s\=\sTrue}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\slog_count\s:\s"Count"\s\=\s10}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*folder\slog_folder\s:\s"Folder"\s\=\s/var/log/pyload_instance1}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\slog_rotate\s:\s"Log\sRotate"\s\=\sTrue}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\slog_size\s:\s"Size\sin\skb"\s\=\s100}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\schange_dl\s:\s"Change\sGroup\sand\sUser\sof\sDownloads"\s\=\sFalse}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\schange_file\s:\s"Change\sfile\smode\sof\sdownloads"\s\=\sFalse}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\schange_group\s:\s"Change\sgroup\sof\srunning\sprocess"\s\=\sFalse}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\schange_user\s:\s"Change\suser\sof\srunning\sprocess"\s\=\sFalse}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\sfile\s:\s"Filemode\sfor\sDownloads"\s\=\s0644}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\sfolder\s:\s"Folder\sPermission\smode"\s\=\s0755}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\sgroup\s:\s"Groupname"\s\=\spyload}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\suser\s:\s"Username"\s\=\spyload}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\saddress\s:\s"Address"\s\=\slocalhost}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*password\spassword\s:\s"Password"\s\=\s}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\sport\s:\s"Port"\s\=\s7070}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sproxy\s:\s"Use\sProxy"\s\=\sFalse}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*http;socks4;socks5\stype\s:\s"Protocol"\s\=\shttp}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\susername\s:\s"Username"\s\=\s}) }
  its('content') { should match(%r{reconnect\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sactivated\s:\s"Use\sReconnect"\s\=\sFalse}) }
  its('content') { should match(%r{reconnect\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*time\sendTime\s:\s"End"\s\=\s0\:00}) }
  its('content') { should match(%r{reconnect\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\smethod\s:\s"Method"\s\=\s}) }
  its('content') { should match(%r{reconnect\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*time\sstartTime\s:\s"Start"\s\=\s0\:00}) }
  its('content') { should match(%r{remote\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sactivated\s:\s"Activated"\s=\sFalse}) }
  its('content') { should match(%r{remote\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*ip\slistenaddr\s:\s"Adress"\s=\s0\.0\.0\.0}) }
  its('content') { should match(%r{remote\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\snolocalauth\s:\s"No\sauthentication\son\slocal\sconnections"\s=\sTrue}) }
  its('content') { should match(%r{remote\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\sport\s:\s"Port"\s=\s7227}) }
  its('content') { should match(%r{ssl\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sactivated\s:\s"Activated"\s\=\sFalse}) }
  its('content') { should match(%r{ssl\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*file\scert\s:\s"SSL\sCertificate"\s\=\s}) }
  its('content') { should match(%r{ssl\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*file\skey\s:\s"SSL\sKey"\s\=\s}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sactivated\s:\s"Activated"\s\=\sTrue}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sbasicauth\s:\s"Use\sbasic\sauth"\s\=\sFalse}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*ip\shost\s:\s"IP"\s\=\s0.0.0.0}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\shttps\s:\s"Use\sHTTPS"\s\=\sFalse}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\sport\s:\s"Port"\s\=\s8001}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\sprefix\s:\s"Path\sPrefix"\s\=\s}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*builtin;threaded;fastcgi;lightweight\sserver\s:\s"Server"\s=\sbuiltin}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*template\s:\s"Template"\s=\sclassic}) }
end

describe file('/var/lib/pyload_instance2/pyload.conf') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'pyload_instance2' }
  its('group') { should eq 'pyload_instance2' }
  its('mode') { should cmp '0600' }
  its('content') { should match(/version\:\s1\s/) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\schunks\s\:\s"Max\sconnections\sfor\sone\sdownload"\s\=\s3}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\sinterface\s:\s"Download\sinterface\sto\sbind\s\(ip\sor\sName\)"\s\=\s}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sipv6\s\:\s"Allow\sIPv6"\s=\sFalse}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\slimit_speed\s:\s"Limit\sDownload\sSpeed"\s\=\sFalse}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\smax_downloads\s:\s"Max\sParallel\sDownloads"\s\=\s3}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\smax_speed\s:\s"Max\sDownload\sSpeed\sin\skb/s"\s\=\s-1}) }
  its('content') { should match(%r{download\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sskip_existing\s:\s"Skip\salready\sexisting\sfiles"\s\=\sFalse}) }
  its('content') { should match(%r{downloadTime\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*time\send\s\:\s"End"\s\=\s0\:00}) }
  its('content') { should match(%r{downloadTime\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*time\sstart\s:\s"Start"\s\=\s0\:00}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\schecksum\s:\s"Use\sChecksum"\s\=\sFalse}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sdebug_mode\s:\s"Debug\sMode"\s\=\sFalse}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*folder\sdownload_folder\s:\s"Download\sFolder"\s\=\s/tmp/downloads_instance2}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sfolder_per_package\s:\s"Create\sfolder\sfor\seach\spackage"\s\=\sTrue}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*en;de;fr;it;es;nl;sv;ru;pl;cs;sr;pt_BR\slanguage\s:\s"Language"\s\=\sen}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\smin_free_space\s:\s"Min\sFree\sSpace\s\(MB\)"\s\=\s1024}) }
  its('content') { should match(%r{general\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\srenice\s:\s"CPU\sPriority"\s\=\s0}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sfile_log\s:\s"File\sLog"\s\=\sTrue}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\slog_count\s:\s"Count"\s\=\s10}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*folder\slog_folder\s:\s"Folder"\s\=\s/var/log/pyload_instance2}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\slog_rotate\s:\s"Log\sRotate"\s\=\sTrue}) }
  its('content') { should match(%r{log\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\slog_size\s:\s"Size\sin\skb"\s\=\s100}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\schange_dl\s:\s"Change\sGroup\sand\sUser\sof\sDownloads"\s\=\sFalse}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\schange_file\s:\s"Change\sfile\smode\sof\sdownloads"\s\=\sFalse}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\schange_group\s:\s"Change\sgroup\sof\srunning\sprocess"\s\=\sFalse}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\schange_user\s:\s"Change\suser\sof\srunning\sprocess"\s\=\sFalse}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\sfile\s:\s"Filemode\sfor\sDownloads"\s\=\s0644}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\sfolder\s:\s"Folder\sPermission\smode"\s\=\s0755}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\sgroup\s:\s"Groupname"\s\=\spyload}) }
  its('content') { should match(%r{permission\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\suser\s:\s"Username"\s\=\spyload}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\saddress\s:\s"Address"\s\=\slocalhost}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*password\spassword\s:\s"Password"\s\=\s}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\sport\s:\s"Port"\s\=\s7070}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sproxy\s:\s"Use\sProxy"\s\=\sFalse}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*http;socks4;socks5\stype\s:\s"Protocol"\s\=\shttp}) }
  its('content') { should match(%r{proxy\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\susername\s:\s"Username"\s\=\s}) }
  its('content') { should match(%r{reconnect\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sactivated\s:\s"Use\sReconnect"\s\=\sFalse}) }
  its('content') { should match(%r{reconnect\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*time\sendTime\s:\s"End"\s\=\s0\:00}) }
  its('content') { should match(%r{reconnect\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\smethod\s:\s"Method"\s\=\s}) }
  its('content') { should match(%r{reconnect\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*time\sstartTime\s:\s"Start"\s\=\s0\:00}) }
  its('content') { should match(%r{remote\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sactivated\s:\s"Activated"\s=\sFalse}) }
  its('content') { should match(%r{remote\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*ip\slistenaddr\s:\s"Adress"\s=\s0\.0\.0\.0}) }
  its('content') { should match(%r{remote\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\snolocalauth\s:\s"No\sauthentication\son\slocal\sconnections"\s=\sTrue}) }
  its('content') { should match(%r{remote\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\sport\s:\s"Port"\s=\s7227}) }
  its('content') { should match(%r{ssl\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sactivated\s:\s"Activated"\s\=\sFalse}) }
  its('content') { should match(%r{ssl\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*file\scert\s:\s"SSL\sCertificate"\s\=\s}) }
  its('content') { should match(%r{ssl\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*file\skey\s:\s"SSL\sKey"\s\=\s}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sactivated\s:\s"Activated"\s\=\sTrue}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\sbasicauth\s:\s"Use\sbasic\sauth"\s\=\sFalse}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*ip\shost\s:\s"IP"\s\=\s0.0.0.0}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*bool\shttps\s:\s"Use\sHTTPS"\s\=\sFalse}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*int\sport\s:\s"Port"\s\=\s8002}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*str\sprefix\s:\s"Path\sPrefix"\s\=\s}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*builtin;threaded;fastcgi;lightweight\sserver\s:\s"Server"\s=\sbuiltin}) }
  its('content') { should match(%r{webinterface\s[a-zA-Z0-9\-\."\:;_='\(\)/\n\s]*template\s:\s"Template"\s=\sclassic}) }
end

describe service('pyload_instance1') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/systemd/system/pyload_instance1.service') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
  its('content') { should match(%r{/opt/pyload_instance1/bin/python /opt/pyload_instance1/bin/pyLoadCore --configdir=/var/lib/pyload_instance1}) }
end

describe processes('pyload_instance1') do
  it { should exist }
end

describe service('pyload_instance2') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/systemd/system/pyload_instance2.service') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
  its('content') { should match(%r{/opt/pyload_instance2/bin/python /opt/pyload_instance2/bin/pyLoadCore --configdir=/var/lib/pyload_instance2}) }
end

describe processes('pyload_instance2') do
  it { should exist }
end
