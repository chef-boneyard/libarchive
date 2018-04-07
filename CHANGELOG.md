# libarchive Cookbook CHANGELOG

This file is used to list changes made in each version of the libarchive cookbook.

## 2.0.0 (2018-04-07)

This cookbook now utilizes the libarchive built into Chef 14 to extract archives. There is no longer a need to install libarchive packages onto the host and because of this the cookbook now works on any platform supported by Chef. The libarchive_file resource has been renamed archive_file and the default recipe no longer performs any installation actions.

## 1.0.0 (2017-04-03)

- Convert file LWRP to custom resource

## 0.7.1 (2017-03-30)

- Update license string to standard Apache-2.0
- Update maintainer information 
- Add source_url and issue_url 
- Add apt-update for debian platforms in test cookbook
- Remove EOL platforms from .kitchen.yml
- Add ubuntu-16.04, update latest centos 6, 7 platforms in .kitchen.yml
- Modify test suite to use test cookbook

## 0.7.0 (2017-03-15)

- Remove broken support for CentOS 5 and the yum-epel cookbook dependency
- Remove the inclusion of apt::default in the default recipe. Apt updating is up to the user in a base role or cookbook
- Resolve cookstyle warnings
