#
# Cookbook Name:: libarchive
# Recipe:: default
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#

include_recipe 'apt::default' if platform_family?('debian')
if platform_family?('redhat')
  include_recipe 'yum-epel::default' if node['platform_version'].to_i == 5
end

package node['libarchive']['package_name'] do
  version node['libarchive']['package_version'] if node['libarchive']['package_version']
  action :nothing
end.run_action(:upgrade)

# TODO: (jbellone) Remove this comment block if we're able to get a
# new cut of the ffi-libarchive gem. Otherwise we need some patches in
# order to get the Archive::Reader#extract method working properly.

# if Chef::Resource::ChefGem.instance_methods(false).include?(:compile_time)
#   chef_gem 'ffi-libarchive' do
#     version '0.1.4'
#     compile_time true
#   end
# else
#   chef_gem 'ffi-libarchive' do
#     version '0.1.4'
#     action :nothing
#   end.run_action(:install)
# end
