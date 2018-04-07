name             'libarchive'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache-2.0'
description      'A library cookbook for extracting archive files'
long_description 'A library cookbook for extracting archive files'
version          '1.0.0'

%w(ubuntu debian redhat centos suse opensuse opensuseleap scientific oracle amazon).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/libarchive'
issues_url 'https://github.com/chef-cookbooks/libarchive/issues'
chef_version '>= 12.7' if respond_to?(:chef_version)
