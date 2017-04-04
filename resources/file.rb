#
# Cookbook Name:: libarchive
# Resource:: file
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#

property :path, String, name_property: true, required: true
property :owner, String
property :group, String
property :mode, [String, Integer], default: '0755'
property :extract_to, String, required: true
property :extract_options, [Array, Symbol], default: []

require 'fileutils'

action :extract do
  unless ::File.exist?(new_resource.path)
    raise Errno::ENOENT, "no archive found at #{new_resource.path}"
  end

  unless Dir.exist?(new_resource.extract_to)
    converge_by("FileUtils.mkdir_p(#{new_resource.extract_to}, mode: #{new_resource.mode})") do
      FileUtils.mkdir_p(new_resource.extract_to, mode: new_resource.mode.to_i)
    end
  end

  Chef::Log.info "libarchive_file[#{new_resource.name}] extracting #{new_resource.path} to #{new_resource.extract_to}"
  LibArchiveCookbook::Helper.extract(new_resource.path, new_resource.extract_to,
    Array(new_resource.extract_options))

  if new_resource.owner || new_resource.group
    converge_by("FileUtils.chown_R(#{new_resource.owner}, #{new_resource.group}, #{new_resource.extract_to})") do
      FileUtils.chown_R(new_resource.owner, new_resource.group, new_resource.extract_to)
    end
  end
end
