#
# Cookbook Name:: libarchive
# Provider:: file
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#

require 'fileutils'

use_inline_resources

action :extract do
  unless ::File.exist?(new_resource.path)
    raise Errno::ENOENT, "no archive found at #{new_resource.path}"
  end

  package "libarchive12" do
    action :nothing
  end.run_action(:install)

  package "libarchive-dev" do
    action :nothing
  end.run_action(:install)

  chef_gem "libarchive-ruby" do
    version "0.0.3"
  end

  directory new_resource.extract_to do
    owner new_resource.owner
    group new_resource.group
    recursive true

    if new_resource.force
      action [:delete, :create]
    else
      action :create
    end
  end

  ruby_block "extracting #{new_resource.path} to #{new_resource.extract_to}" do
    block do
      require 'archive'

      updated = LibArchiveCookbook::Helper.extract(new_resource.path, new_resource.extract_to,
        Array(new_resource.extract_options))

      if new_resource.owner || new_resource.group
        FileUtils.chown_R(new_resource.owner, new_resource.group, new_resource.extract_to)
      end

      new_resource.updated_by_last_action(updated)
    end

    action :run
  end
end
