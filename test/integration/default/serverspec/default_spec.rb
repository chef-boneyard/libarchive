require 'spec_helper'

package = if os[:family] == 'redhat'
            'libarchive-devel'
          elsif %w(debian ubuntu).include?(os[:family])
            'libarchive-dev'
          else
            'libarchive'
          end

describe package(package) do
  it { should be_installed }
end
