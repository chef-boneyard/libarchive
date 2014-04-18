# libarchive-cookbook

A library cookbook that provides LWRP's for extracting archive files

## Supported Platforms

* Ubuntu

## libarchive_file Resource/Provider

### Actions

- **extract** - extracts the contents of the archive to the destination on disk. (default)

### Paramter Attributes

- **path** - filepath to the archive to extract (name attribute)
- **owner** - set the owner of the extracted files
- **group** - set the group of the extracted files
- **mode** - set the mode of the extracted files
- **extract_to** - filepath to extract the contents of the archive to
- **extract_options** - an array of symbols representing extraction flags. See extract options below.

### Extract Options

- `:no_overwrite` - don't overwrite files if they already exist

## License and Authors

Author:: Jamie Winsor (<jamie@vialstudios.com>)
