#
# Cookbook Name:: libarchive
# Attribute:: default
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#
default['libarchive']['package_name'] = if platform_family?('debian')
                                          'libarchive-dev'
                                        elsif platform_family?('rhel')
                                          'libarchive-devel'
                                        else
                                          'libarchive'
                                        end
