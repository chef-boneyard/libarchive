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

description 'Use the archive_file resource to extract archive files to disk. This resource uses the libarchive library to extract multiple archive formats including tar, gzip, bzip, and zip formats.'

property :path, String,
         name_property: true,
         coerce: proc { |f| ::File.expand_path(f) },
         description: "An optional property to set the file path to the archive to extract if it differs from the resource block's name."

property :owner, String,
         description: 'The owner of the extracted files'

property :group, String,
         description: 'The group of the extracted files'

property :mode, [String, Integer],
         description: 'The mode of the extracted files',
         default: '755'

property :destination, String,
         description: 'The file path to extract the archive file to.',
         required: true

property :options, [Array, Symbol],
         description: 'An array of symbols representing extraction flags. Example: :no_overwrite to prevent overwriting files on disk.',
         default: lazy { [] }

property :overwrite, [TrueClass, FalseClass, :auto],
         description: 'Should the resource overwrite the destination file contents if they already exist? If set to :auto the date stamp of files within the archive will be compared to those on disk, and if newer the disk contents will be overwritten. Be aware that this method does not work for all archive types, and should be tested before being used as it may result in the files being replaced during each client run.',
         default: false

# backwards compatibility for the legacy names when we only had an :extract action
alias_method :extract_options, :options
alias_method :extract_to, :destination

require 'fileutils'

action :extract do
  description 'Extract and archive file.'

  unless ::File.exist?(new_resource.path)
    raise Errno::ENOENT, "No archive found at #{new_resource.path}! Cannot continue."
  end

  if !::File.exist?(new_resource.destination)
    Chef::Log.trace("File or directory does not exist at destination path: #{new_resource.destination}")

    converge_by("create directory #{new_resource.destination}") do
      FileUtils.mkdir_p(new_resource.destination, mode: new_resource.mode.to_i)
    end

    extract(new_resource.path, new_resource.destination, Array(new_resource.options))
  else
    Chef::Log.trace("File or directory exists at destination path: #{new_resource.destination}.")

    if new_resource.overwrite == true ||
       (new_resource.overwrite == :auto && archive_differs_from_disk?(new_resource.path, new_resource.destination))
      Chef::Log.debug("Overwriting existing content at #{new_resource.destination} due to resource's overwrite property settings.")

      extract(new_resource.path, new_resource.destination, Array(new_resource.options))
    else
      Chef::Log.debug("Not extracting archive as #{new_resource.destination} exists and resource not set to overwrite.")
    end
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

  # try to determine if the resource has updated or not by checking for files that are in the
  # archive, but not on disk or files with a non-matching mtime
  #
  # @param [String] src
  # @param [String] dest
  #
  # @return [Boolean]
  def archive_differs_from_disk?(src, dest)
    require 'ffi-libarchive'

    modified = false
    Dir.chdir(dest) do
      archive = Archive::Reader.open_filename(src)
      Chef::Log.trace("Beginning the comparison of file mtime between contents of #{src} and #{dest}")
      archive.each_entry do |e|
        pathname = ::File.expand_path(e.pathname)
        if ::File.exist?(pathname)
          Chef::Log.trace("#{pathname} mtime is #{::File.mtime(pathname)} and archive is #{e.mtime}")
          modified = true unless ::File.mtime(pathname) == e.mtime
        else
          Chef::Log.trace("#{pathname} doesn't exist on disk, but exists in the archive")
          modified = true
        end
      end
    end
    modified
  end

  # extract the archive
  #
  # @param [String] src
  # @param [String] dest
  # @param [Array] options
  #
  # @return [void]
  def extract(src, dest, options = [])
    require 'ffi-libarchive'

    converge_by("extract #{src} to #{dest}") do
      flags = [options].flatten.map { |option| extract_option_map[option] }.compact.reduce(:|)

      Dir.chdir(dest) do
        archive = Archive::Reader.open_filename(src)

        archive.each_entry do |e|
          archive.extract(e, flags.to_i)
        end
        archive.close
      end
    end
  end
end
