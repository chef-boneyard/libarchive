#
# Cookbook Name:: libarchive
# Library:: matchers
#
# Author:: John Bellone (<jbellone@bloomberg.net>)
#

if defined?(ChefSpec)
  ChefSpec.define_matcher :libarchive_file
  def extract_libarchive_file(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:libarchive_file, :extract, resource_name)
  end
end
