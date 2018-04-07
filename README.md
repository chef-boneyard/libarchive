# libarchive-cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/libarchive.svg?branch=master)](https://travis-ci.org/chef-cookbooks/libarchive) [![Cookbook Version](https://img.shields.io/cookbook/v/libarchive.svg)](https://supermarket.chef.io/cookbooks/libarchive)

Resources for extracting archives of all types with Chef

## Requirements

- Chef >= 14.0

## Supported Platforms

- Ubuntu / Debian
- RHEL / Amazon / Fedora
- SLES / openSUSE

## Usage

```ruby
archive_file "my_archive.tar.gz" do
  path "/path/to/artifact/my_archive.tar.gz"
  extract_to "/path/to/extraction"
  owner "reset"
  group "reset"

  action :extract
end
```

## archive_file Resource

### Actions

- **extract** - extracts the contents of the archive to the destination on disk. (default)

### Properties

- **path** - filepath to the archive to extract (name attribute)
- **owner** - set the owner of the extracted files
- **group** - set the group of the extracted files
- **mode** - set the mode of the extracted files
- **extract_to** - filepath to extract the contents of the archive to
- **extract_options** - an array of symbols representing extraction flags. See extract options below.

### Extract Options

- `:no_overwrite` - don't overwrite files if they already exist

## License and Authors

- Author:: Jamie Winsor ([jamie@vialstudios.com](mailto:jamie@vialstudios.com))
- Author:: Tim Smith ([tsmith@chef.io](mailto:tsmith@chef.io))
- Author:: John Bellone ([jbellone@bloomberg.net](mailto:jbellone@bloomberg.net))
- Author:: Jennifer Davis ([sigje@chef.io](mailto:sigje@chef.io))

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
