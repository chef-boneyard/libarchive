%w(tourism.tar.gz tourism.tar.xz tourism.zip).each do |archive|
   cookbook_file File.join(Chef::Config[:file_cache_path], archive) do
     source archive
   end

   archive_file archive do
     path File.join(Chef::Config[:file_cache_path], archive)
     extract_to File.join(Chef::Config[:file_cache_path], archive.gsub('.', '_'))
   end
end
