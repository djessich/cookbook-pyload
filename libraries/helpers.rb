#
# Copyright 2019 Dominik Jessich
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

module PyloadCookbook
  module Helpers
    # Returns the platforms root group.
    #
    # @return The platforms root group.
    def root_group
      node['platform_family'] == 'freebsd' ? 'wheel' : 'root'
    end

    # Returns the path to python executable.
    #
    # @return The path to python executable.
    # def python_bin
    #   case node['platform_family']
    #   when 'debian', 'fedora', 'rhel', 'suse'
    #     '/usr/bin/python'
    #   when 'arch'
    #     '/usr/bin/python2'
    #   when 'freebsd'
    #     '/usr/local/bin/python2.7'
    #   end
    # end
  end
end

Chef::Recipe.send(:include, PyloadCookbook::Helpers)
Chef::Resource.send(:include, PyloadCookbook::Helpers)
Chef::Provider.send(:include, PyloadCookbook::Helpers)
