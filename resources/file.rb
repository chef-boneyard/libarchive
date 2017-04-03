#
# Cookbook Name:: libarchive
# Resource:: file
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#

property :path, kind_of: String, name_property: true, required: true
property :owner, kind_of: String
property :group, kind_of: String
property :mode, kind_of: Integer, default: 0755
property :extract_to, kind_of: String, required: true
property :extract_options, kind_of: [Array, Symbol], default: []

require 'fileutils'

action :extract do
  unless ::File.exist?(new_resource.path)
    raise Errno::ENOENT, "no archive found at #{new_resource.path}"
  end

  FileUtils.mkdir_p(new_resource.extract_to, mode: new_resource.mode)

  Chef::Log.info "libarchive_file[#{new_resource.name}] extracting #{new_resource.path} to #{new_resource.extract_to}"
  LibArchiveCookbook::Helper.extract(new_resource.path, new_resource.extract_to,
    Array(new_resource.extract_options))

  if new_resource.owner || new_resource.group
    FileUtils.chown_R(new_resource.owner, new_resource.group, new_resource.extract_to)
  end
end
