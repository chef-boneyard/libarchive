source 'https://supermarket.chef.io'
cookbook 'ffi-libarchive', path: '~/Projects/ffi-libarchive-cookbook/pkg/ffi-libarchive-1.0.0'
metadata

group :test, :integration do
  cookbook 'test-libarchive', path: File.expand_path('../test/fixtures/cookbooks/test', __FILE__)
end
