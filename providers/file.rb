#
# Cookbook Name:: libarchive
# Provider:: file
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#

require 'fileutils'

action :extract do
  unless ::File.exist?(new_resource.path)
    raise Errno::ENOENT, "no archive found at #{new_resource.path}"
  end

  package "libarchive-dev" do
    action :nothing
  end.run_action(:install)

  chef_gem "libarchive-ruby" do
    version "0.0.3"
  end

  FileUtils.mkdir_p(new_resource.extract_to, mode: new_resource.mode)

  Chef::Log.info "libarchive_file[#{new_resource.name}] extracting #{new_resource.path} to #{new_resource.extract_to}"
  updated = LibArchiveCookbook::Helper.extract(new_resource.path, new_resource.extract_to,
    Array(new_resource.extract_options))

  if new_resource.owner || new_resource.group
    FileUtils.chown_R(new_resource.owner, new_resource.group, new_resource.extract_to)
  end

  new_resource.updated_by_last_action(updated)
end
