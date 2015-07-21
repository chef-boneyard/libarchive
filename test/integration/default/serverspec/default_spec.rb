require 'spec_helper'

describe package('libarchive') do
  it { should be_installed }
end
