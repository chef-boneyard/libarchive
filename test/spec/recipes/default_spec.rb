require 'spec_helper'

describe_recipe 'libarchive::default' do
  context 'with default attributes' do
    cached(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

    it { expect(chef_run).to install_chef_gem('ffi-libarchive') }
    it 'converges successfully' do
      chef_run
    end
  end
end
