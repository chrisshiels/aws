require 'spec_helper'


# Set minimum length before truncation occurs in reports.
RSpec::Support::ObjectFormatter.default_instance.max_formatted_output_length =
  1024


describe vpc('vpc-elbasgrds-dev') do
  it { should exist }
  it { should be_available }
  its(:cidr_block) { should eq '10.0.0.0/16' }
  it { should have_route_table('rtb-elbasgrds-dev-public') }
  it { should have_route_table('rtb-elbasgrds-dev-app-1a') }
  it { should have_route_table('rtb-elbasgrds-dev-app-1b') }
  it { should have_route_table('rtb-elbasgrds-dev-data-1a') }
  it { should have_route_table('rtb-elbasgrds-dev-data-1b') }
end


{
  'eu-west-1a' => '10.0.1.0/24',
  'eu-west-1b' => '10.0.2.0/24'
}.each do | az, cidr |
  describe subnet("sn-elbasgrds-dev-public-#{az.split('-').last()}") do
    it { should exist }
    it { should be_available }
    it { should belong_to_vpc('vpc-elbasgrds-dev') }
    its(:cidr_block) { should eq cidr }
  end
end


{
  'eu-west-1a' => '10.0.4.0/24',
  'eu-west-1b' => '10.0.5.0/24'
}.each do | az, cidr |
  describe subnet("sn-elbasgrds-dev-app-#{az.split('-').last()}") do
    it { should exist }
    it { should be_available }
    it { should belong_to_vpc('vpc-elbasgrds-dev') }
    its(:cidr_block) { should eq cidr }
  end
end


{
  'eu-west-1a' => '10.0.7.0/24',
  'eu-west-1b' => '10.0.8.0/24'
}.each do | az, cidr |
  describe subnet("sn-elbasgrds-dev-data-#{az.split('-').last()}") do
    it { should exist }
    it { should be_available }
    it { should belong_to_vpc('vpc-elbasgrds-dev') }
    its(:cidr_block) { should eq cidr }
  end
end


describe internet_gateway('igw-elbasgrds-dev') do
  it { should exist }
  it { should be_attached_to('vpc-elbasgrds-dev') }
end


describe route_table('rtb-elbasgrds-dev-public') do
  it { should exist }
  it { should belong_to_vpc('vpc-elbasgrds-dev') }
  it { should have_route('10.0.0.0/16').target(gateway: 'local') }
  it { should have_subnet('sn-elbasgrds-dev-public-1a') }
  it { should have_subnet('sn-elbasgrds-dev-public-1b') }
  its('routes.last.gateway_id') { should match /^igw-/ }
end


describe route_table('rtb-elbasgrds-dev-app-1a') do
  it { should exist }
  it { should belong_to_vpc('vpc-elbasgrds-dev') }
  it { should have_route('10.0.0.0/16').target(gateway: 'local') }
  it { should have_subnet('sn-elbasgrds-dev-app-1a') }
  its('routes.last.nat_gateway_id') { should match /^nat-/ }
end


describe route_table('rtb-elbasgrds-dev-app-1b') do
  it { should exist }
  it { should belong_to_vpc('vpc-elbasgrds-dev') }
  it { should have_route('10.0.0.0/16').target(gateway: 'local') }
  it { should have_subnet('sn-elbasgrds-dev-app-1b') }
  its('routes.last.nat_gateway_id') { should match /^nat-/ }
end


describe route_table('rtb-elbasgrds-dev-data-1a') do
  it { should exist }
  it { should belong_to_vpc('vpc-elbasgrds-dev') }
  it { should have_route('10.0.0.0/16').target(gateway: 'local') }
  it { should have_subnet('sn-elbasgrds-dev-data-1a') }
  its('routes.last.nat_gateway_id') { should match /^nat-/ }
end


describe route_table('rtb-elbasgrds-dev-data-1b') do
  it { should exist }
  it { should belong_to_vpc('vpc-elbasgrds-dev') }
  it { should have_route('10.0.0.0/16').target(gateway: 'local') }
  it { should have_subnet('sn-elbasgrds-dev-data-1b') }
  its('routes.last.nat_gateway_id') { should match /^nat-/ }
end


describe iam_role('role-elbasgrds-dev-instance') do
  it { should exist }
  its(:assume_role_policy_document) { should eq '%7B%22Version%22%3A%222012-10-17%22%2C%22Statement%22%3A%5B%7B%22Sid%22%3A%22%22%2C%22Effect%22%3A%22Allow%22%2C%22Principal%22%3A%7B%22Service%22%3A%22ec2.amazonaws.com%22%7D%2C%22Action%22%3A%22sts%3AAssumeRole%22%7D%5D%7D' }
end


describe iam_policy('policy-elbasgrds-dev-instance') do
  it { should exist }
  it { should be_attachable }
  its(:attachment_count) { should eq 1 }
  it { should be_attached_to_role('role-elbasgrds-dev-instance') }
end


describe security_group('sg-elbasgrds-dev-bastion') do
  it { should exist }
  it { should belong_to_vpc('vpc-elbasgrds-dev') }
  its(:outbound) { should be_opened.protocol('all').for('0.0.0.0/0') }
  its(:inbound) { should be_opened(22).protocol('tcp').for('0.0.0.0/0') }
end


describe ec2('elbasgrds-dev-bastion1') do
  it { should exist }
  it { should be_running }
  its(:instance_type) { should eq 't2.micro' }
  it { should have_security_group('sg-elbasgrds-dev-bastion') }
  it { should have_security_group('sg-elbasgrds-dev-all') }
  it { should belong_to_vpc('vpc-elbasgrds-dev') }
  it { should belong_to_subnet('sn-elbasgrds-dev-public-1a') }
  it { should have_ebs('elbasgrds-dev-bastion1') }
  its(:key_name) { should eq 'aws' }
  it { should have_iam_instance_profile('instanceprofile-elbasgrds-dev-instance') }
  its(:hypervisor) { should eq 'xen' }
  its(:virtualization_type) { should eq 'hvm' }
end


describe security_group('sg-elbasgrds-dev-app-elb') do
  it { should exist }
  it { should belong_to_vpc('vpc-elbasgrds-dev') }
  its(:outbound) { should be_opened.protocol('all').for('0.0.0.0/0') }
  its(:inbound) { should be_opened(80).protocol('tcp').for('0.0.0.0/0') }
end


describe elb('elb-elbasgrds-dev-app') do
  it { should exist }
  it { should belong_to_vpc('vpc-elbasgrds-dev') }
  it { should have_subnet('sn-elbasgrds-dev-public-1a') }
  it { should have_subnet('sn-elbasgrds-dev-public-1b') }
  it { should have_security_group('sg-elbasgrds-dev-app-elb') }
  it { should have_security_group('sg-elbasgrds-dev-all') }
  it { should have_listener(protocol: 'HTTP',
			    port: 80,
			    instance_protocol: 'HTTP',
			    instance_port: 80) }
  its(:health_check_target) { should eq 'HTTP:80/' }
  its(:health_check_interval) { should eq 30 }
  its(:health_check_unhealthy_threshold) { should eq 2 }
  its(:health_check_healthy_threshold) { should eq 2 }
  its(:health_check_timeout) { should eq 10 }
end


describe security_group('sg-elbasgrds-dev-app-asglc') do
  it { should exist }
  it { should belong_to_vpc('vpc-elbasgrds-dev') }
  its(:outbound) { should be_opened.protocol('all').for('0.0.0.0/0') }
  its(:inbound) { should be_opened(22).protocol('tcp').for('sg-elbasgrds-dev-bastion') }
  its(:inbound) { should be_opened(80).protocol('tcp').for('sg-elbasgrds-dev-bastion') }
  its(:inbound) { should be_opened(80).protocol('tcp').for('sg-elbasgrds-dev-app-elb') }
end


describe launch_configuration('asglc-elbasgrds-dev-app') do
  it { should exist }
  its(:instance_type) { should eq 't2.micro' }
  it { should have_security_group('sg-elbasgrds-dev-app-asglc') }
  it { should have_security_group('sg-elbasgrds-dev-all') }
  its(:associate_public_ip_address) { should eq nil }
  its(:key_name) { should eq 'aws' }
  its(:iam_instance_profile) { should eq 'instanceprofile-elbasgrds-dev-instance' }
end


describe autoscaling_group('asg-elbasgrds-dev-app') do
  it { should exist }
  it { should have_launch_configuration('asglc-elbasgrds-dev-app') }
  it { should have_elb('elb-elbasgrds-dev-app') }
  its(:min_size) { should eq 2 }
  its(:max_size) { should eq 2 }
  its(:desired_capacity) { should eq 2 }
  its(:default_cooldown) { should eq 30 }
  its(:health_check_grace_period) { should eq 60 }
  its(:health_check_type) { should eq 'EC2' }
end


describe security_group('sg-elbasgrds-dev-app-db') do
  it { should exist }
  it { should belong_to_vpc('vpc-elbasgrds-dev') }
  its(:outbound) { should be_opened.protocol('all').for('0.0.0.0/0') }
  its(:inbound) { should be_opened(3306).protocol('tcp').for('sg-elbasgrds-dev-app-asglc') }
end


describe rds('db-elbasgrds-dev-app') do
  it { should exist }
  it { should be_available }
  its(:engine) { should eq 'mysql' }
  its(:engine_version) { should eq '5.7.19' }
  its(:license_model) { should eq 'general-public-license' }
  its('resource.endpoint.port') { should eq 3306 }
  its(:publicly_accessible) { should eq false }
  it { should have_security_group('sg-elbasgrds-dev-app-db') }
  it { should have_security_group('sg-elbasgrds-dev-all') }
  it { should belong_to_db_subnet_group('dbsng-elbasgrds-dev-app') }
  it { should belong_to_vpc('vpc-elbasgrds-dev') }
  its(:multi_az) { should eq false }
  its(:db_instance_class) { should eq 'db.t2.micro' }
  its(:allocated_storage) { should eq 5 }
  its(:storage_type) { should eq 'gp2' }
  its(:master_username) { should eq 'admin' }
  its(:db_name) { should eq 'db' }
  its(:preferred_backup_window) { should eq '01:00-03:00' }
  its(:backup_retention_period) { should eq 7 }
  its(:preferred_maintenance_window) { should eq 'mon:04:00-mon:06:00' }
  its(:iam_database_authentication_enabled) { should eq false }
  it { should have_tag('Name').value('db-elbasgrds-dev-app') }
  it { should have_db_parameter_group('default.mysql5.7') }
  it { should have_option_group('default:mysql-5-7') }
end
