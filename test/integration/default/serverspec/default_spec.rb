require 'spec_helper'

if os[:family] == 'redhat'
  package = 'libarchive-devel'
elsif ['debian', 'ubuntu'].include?(os[:family])
  package = 'libarchive-dev'
else
  package = 'libarchive'
end

describe package(package) do
  it { should be_installed }
end
