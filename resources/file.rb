#
# Cookbook Name:: libarchive
# Resource:: file
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#

resource_name :archive_file
provides :libarchive_file

property :path, String, name_property: true
property :owner, String
property :group, String
property :mode, [String, Integer], default: '755'
property :extract_to, String, required: true
property :extract_options, [Array, Symbol], default: lazy { [] }

require 'fileutils'

action :extract do
  unless ::File.exist?(new_resource.path)
    raise Errno::ENOENT, "No archive found at #{new_resource.path}!"
  end

  unless Dir.exist?(new_resource.extract_to)
    converge_by("create directory #{new_resource.extract_to}") do
      FileUtils.mkdir_p(new_resource.extract_to, mode: new_resource.mode.to_i)
    end
  end

  converge_by("extract #{new_resource.path} to #{new_resource.extract_to}") do
    LibArchiveCookbook::Helper.extract(new_resource.path, new_resource.extract_to,
      Array(new_resource.extract_options))
  end

  if new_resource.owner || new_resource.group
    converge_by("set owner of #{new_resource.extract_to} to #{new_resource.owner}:#{new_resource.group}") do
      FileUtils.chown_R(new_resource.owner, new_resource.group, new_resource.extract_to)
    end
  end
end
