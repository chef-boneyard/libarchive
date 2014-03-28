#
# Cookbook Name:: libarchive
# Library:: helper
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#

module LibArchiveCookbook
  module Helper
    class << self
      # This can't be a constant since we might not have required 'archive' yet
      def extract_option_map
        {
          owner: ::Archive::EXTRACT_OWNER,
          permissions: ::Archive::EXTRACT_PERM,
          time: ::Archive::EXTRACT_TIME,
          no_overwrite: ::Archive::EXTRACT_NO_OVERWRITE,
          acl: ::Archive::EXTRACT_ACL,
          fflags: ::Archive::EXTRACT_FFLAGS,
          extended_information: ::Archive::EXTRACT_XATTR,
          xattr: ::Archive::EXTRACT_XATTR,
        }
      end

      # @param [String] src
      # @param [String] dest
      # @param [Array] extract_options
      def extract(src, dest, extract_options = [])
        extract_options ||= Array.new
        extract_options.collect! { |option| extract_option_map[option] }.compact!

        Dir.chdir(dest) do
          ::Archive.new(src).extract(extract: extract_options.reduce(:|))
        end

        true
      end
    end
  end
end
