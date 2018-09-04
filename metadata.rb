name             'libarchive'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache-2.0'
description      'A library cookbook for extracting archive files'
long_description 'A library cookbook for extracting archive files'
version          '2.0.0'

%w(windows ubuntu debian redhat centos suse opensuse opensuseleap scientific oracle amazon).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/libarchive'
issues_url 'https://github.com/chef-cookbooks/libarchive/issues'
chef_version '>= 14.0'

gem 'ffi-libarchive'
