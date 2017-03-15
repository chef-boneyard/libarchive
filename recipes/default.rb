#
# Cookbook Name:: libarchive
# Recipe:: default
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#

package node[:libarchive][:package_name] do
  version node[:libarchive][:package_version] if node[:libarchive][:package_version]
  action :nothing
end.run_action(:upgrade)

if Chef::Resource::ChefGem.instance_methods(false).include?(:compile_time)
  chef_gem 'ffi-libarchive' do
    version '~> 0.2.0'
    compile_time true
  end
else
  chef_gem 'ffi-libarchive' do
    version '~> 0.2.0'
    action :nothing
  end.run_action(:install)
end
