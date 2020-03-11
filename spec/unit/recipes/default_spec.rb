#
# Cookbook:: mongodb_cookbook
# Spec:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'mongodb_cookbook::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'ubuntu', '16.04'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'should create a mongod.conf template in /etc/mongod.conf' do
      expect(chef_run).to create_template('/etc/mongod.conf').with_variables(port: 27017, bind_ip: '0.0.0.0')
    end

    it 'should create a mongod.service template in /lib/systemd/system/mongod.service' do
      expect(chef_run).to create_template('/lib/systemd/system/mongod.service')
    end

    it 'enables the mongod service' do
      expect(chef_run).to enable_service 'mongod'
    end

    it 'starts the mongod service' do
      expect(chef_run).to start_service 'mongod'
    end
  end
end
