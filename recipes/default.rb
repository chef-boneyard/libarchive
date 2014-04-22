#
# Cookbook Name:: libarchive
# Recipe:: default
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#

node.set[:'build-essential'][:compile_time] = true
include_recipe "build-essential::default"

case
when platform_family?("debian")
  package "libarchive-dev" do
    action :nothing
  end.run_action(:install)
when platform_family?("rhel")
  package "libarchive" do
    action :nothing
  end.run_action(:install)
  package "libarchive-devel" do
    action :nothing
  end.run_action(:install)
else
  Chef::Application.fatal! "[libarchive] unsupported platform family: #{node[:platform_family]}"
end

chef_gem "libarchive-ruby" do
  version "0.0.3"
end
