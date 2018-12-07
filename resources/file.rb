#
# Cookbook Name:: libarchive
# Resource:: file
#
# Copyright:: 2017-2018 Chef Software, Inc.
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
# Author:: Tim Smith (<tsmith@chef.io>)
#

resource_name :archive_file
provides :libarchive_file

property :path, String, name_property: true
property :owner, String
property :group, String
property :mode, [String, Integer], default: '755'
property :destination, String, required: true
property :options, [Array, Symbol], default: lazy { [] }

# backwards compatibility for the legacy names when we only had an :extract action
alias_method :extract_options, :options
alias_method :extract_to, :destination

require 'fileutils'

action :extract do
  unless ::File.exist?(new_resource.path)
    raise Errno::ENOENT, "No archive found at #{new_resource.path}!"
  end

  unless Dir.exist?(new_resource.destination)
    converge_by("create directory #{new_resource.destination}") do
      FileUtils.mkdir_p(new_resource.destination, mode: new_resource.mode.to_i)
    end
  end

  converge_by("extract #{new_resource.path} to #{new_resource.destination}") do
    extract(new_resource.path, new_resource.destination,
      Array(new_resource.options))
  end

  if new_resource.owner || new_resource.group
    converge_by("set owner of #{new_resource.destination} to #{new_resource.owner}:#{new_resource.group}") do
      FileUtils.chown_R(new_resource.owner, new_resource.group, new_resource.destination)
    end
  end
end

action_class do
  # This can't be a constant since we might not have required 'ffi-libarchive' yet.
  def extract_option_map
    {
      owner: Archive::EXTRACT_OWNER,
      permissions: Archive::EXTRACT_PERM,
      time: Archive::EXTRACT_TIME,
      no_overwrite: Archive::EXTRACT_NO_OVERWRITE,
      acl: Archive::EXTRACT_ACL,
      fflags: Archive::EXTRACT_FFLAGS,
      extended_information: Archive::EXTRACT_XATTR,
      xattr: Archive::EXTRACT_XATTR,
      no_overwrite_newer: Archive::EXTRACT_NO_OVERWRITE_NEWER,
    }
  end

  # @param [String] src
  # @param [String] dest
  # @param [Array] options
  #
  # @return [Boolean]
  def extract(src, dest, options = [])
    require 'ffi-libarchive'

    flags = [options].flatten.map { |option| extract_option_map[option] }.compact.reduce(:|)
    modified = false

    Dir.chdir(dest) do
      archive = Archive::Reader.open_filename(src)

      archive.each_entry do |e|
        pathname = ::File.expand_path(e.pathname)
        if ::File.exist?(pathname)
          modified = true unless ::File.mtime(pathname) == e.mtime
        else
          modified = true
        end

        archive.extract(e, flags.to_i)
      end
      archive.close
    end
    modified
  end
end
