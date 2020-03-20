#
# Cookbook:: mongodb_cookbook
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
include_recipe 'apt'
apt_update 'update_sources' do
  action :update
end

# include_recipe 'sc-mongodb::default'

apt_repository 'mongodb-org' do
  uri "http://repo.mongodb.org/apt/ubuntu"
  distribution "xenial/mongodb-org/3.2"
  components ["multiverse"]
  keyserver "hkp://keyserver.ubuntu.com:80"
  key "EA312927"
end

package 'mongodb-org' do
  options '--allow-unauthenticated'
  action :upgrade
end


template '/etc/mongod.conf' do
  source 'mongod.conf.erb'
  variables port: node['mongodb']['port'], bind_ip: node['mongodb']['bind_ip']
  mode '777'
  owner 'root'
  group 'root'
  notifies :restart, 'service[mongod]'
end

template '/lib/systemd/system/mongod.service' do
  source 'mongod.service.erb'
  mode '777'
  owner 'root'
  group 'root'
  notifies :restart, 'service[mongod]'
end

execute 'download_metricbeat' do
  command 'curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.6.1-amd64.deb'
end

execute 'install_metricbeat' do
  command 'sudo dpkg -i metricbeat-7.6.1-amd64.deb'
end

template 'etc/metricbeat/metricbeat.yml' do
  source 'metricbeat.yml.erb'
  mode '777'
  owner 'root'
  group 'root'
end

execute 'fix_template' do
  command 'sudo chmod go-w /etc/metricbeat/metricbeat.yml'
end

execute 'enable_module' do
  command 'sudo metricbeat modules enable mongodb'
end

execute 'enable_module' do
  command 'sudo metricbeat modules enable system'
end

execute 'setup_dasboards' do
  command 'sudo metricbeat setup'
end

execute 'download_filebeat' do
  command 'curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.6.1-amd64.deb'
end

execute 'install_filebeat' do
  command 'sudo dpkg -i filebeat-7.6.1-amd64.deb'
end

template 'etc/filebeat/filebeat.yml' do
  source 'filebeat.yml.erb'
  mode '777'
  owner 'root'
  group 'root'
end

execute 'fix_template' do
  command 'sudo chmod go-w /etc/filebeat/filebeat.yml'
end

execute 'enable_module' do
  command 'sudo filebeat modules enable system'
end

execute 'setup_dasboards' do
  command 'sudo filebeat setup'
end

service 'metricbeat' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

service 'filebeat' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

service 'mongod' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end
