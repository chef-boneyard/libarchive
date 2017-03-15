# libarchive Cookbook CHANGELOG

This file is used to list changes made in each version of the libarchive cookbook.

## 0.7.0 (2017-03-15)

- Remove broken support for CentOS 5 and the yum-epel cookbook dependency
- Remove the inclusion of apt::default in the default recipe. Apt updating is up to the user in a base role or cookbook
- Resolve cookstyle warnings
