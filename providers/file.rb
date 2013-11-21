#
# Cookbook Name:: libarchive
# Provider:: file
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#

require 'fileutils'

action :extract do
  package "libarchive12" do
    action :nothing
  end.run_action(:install)

  package "libarchive-dev" do
    action :nothing
  end.run_action(:install)

  chef_gem "libarchive-ruby"

  Chef::Log.info "libarchive_file[#{new_resource.path}] extracting to #{new_resource.extract_to}"
  updated = extract(new_resource.path, new_resource.extract_to, force: new_resource.force, owner: new_resource.owner,
    group: new_resource.group)
  new_resource.updated_by_last_action(updated)
end

private

  # @param [String] @src
  # @param [String] dest
  #
  # @option options [String] :owner
  # @option options [String] :group
  def extract(src, dest, options = {})
    require 'archive'

    unless ::File.exist?(src)
      raise Errno::ENOENT, "no archive found at #{src}"
    end

    if options[:force]
      FileUtils.rm_rf(dest)
    end

    return false if ::File.exist?(dest)

    FileUtils.mkdir_p(dest)
    Dir.chdir(dest) do
      ::Archive.new(src).extract
    end

    if options[:owner] || options[:group]
      FileUtils.chown_R(options[:owner], options[:group], dest)
    end

    true
  end
