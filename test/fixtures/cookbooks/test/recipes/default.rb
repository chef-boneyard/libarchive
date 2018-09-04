zipball = remote_file 'twbs-v3.3.4.zip' do
  path File.join(Chef::Config[:file_cache_path], name)
  source 'https://github.com/twbs/bootstrap/releases/download/v3.3.4/bootstrap-3.3.4-dist.zip'
  checksum '9af5ebe4e079ac0a07d6785852b62342ac38ef8186352e7ad1f534a16e7a0672'
end

archive_file 'twbs-v3.3.4.zip' do
  path zipball.path
  extract_to File.join(File.dirname(zipball.path), 'twbs-v3.3.4')
end
