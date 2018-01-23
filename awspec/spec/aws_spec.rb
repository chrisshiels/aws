require 'spec_helper'


# Set minimum length before truncation occurs in reports.
RSpec::Support::ObjectFormatter.default_instance.max_formatted_output_length =
  1024


describe vpc('vpc-dev') do
  it { should exist }
  it { should be_available }
  its(:cidr_block) { should eq '10.0.0.0/16' }
  it { should have_route_table('rtb-dev-public') }
  it { should have_route_table('rtb-dev-private') }
end


{
  'eu-west-1a' => '10.0.1.0/24',
  'eu-west-1b' => '10.0.2.0/24',
  'eu-west-1c' => '10.0.3.0/24'
}.each do | az, cidr |
  describe subnet("sn-dev-public-#{az.split('-').last()}") do
    it { should exist }
    it { should be_available }
    it { should belong_to_vpc('vpc-dev') }
    its(:cidr_block) { should eq cidr }
  end
end


{
  'eu-west-1a' => '10.0.4.0/24',
  'eu-west-1b' => '10.0.5.0/24',
  'eu-west-1c' => '10.0.6.0/24'
}.each do | az, cidr |
  describe subnet("sn-dev-private-#{az.split('-').last()}") do
    it { should exist }
    it { should be_available }
    it { should belong_to_vpc('vpc-dev') }
    its(:cidr_block) { should eq cidr }
  end
end


describe internet_gateway('igw-dev') do
  it { should exist }
  it { should be_attached_to('vpc-dev') }
end


describe route_table('rtb-dev-public') do
  it { should exist }
  it { should belong_to_vpc('vpc-dev') }
  it { should have_route('10.0.0.0/16').target(gateway: 'local') }
  it { should have_subnet('sn-dev-public-1a') }
  it { should have_subnet('sn-dev-public-1b') }
  it { should have_subnet('sn-dev-public-1c') }
  its('routes.last.gateway_id') { should match /^igw-/ }
end


describe route_table('rtb-dev-private') do
  it { should exist }
  it { should belong_to_vpc('vpc-dev') }
  it { should have_route('10.0.0.0/16').target(gateway: 'local') }
  it { should have_subnet('sn-dev-private-1a') }
  it { should have_subnet('sn-dev-private-1b') }
  it { should have_subnet('sn-dev-private-1c') }
  its('routes.last.nat_gateway_id') { should match /^nat-/ }
end


describe iam_role('role-dev-instance') do
  it { should exist }
  its(:assume_role_policy_document) { should eq '%7B%22Version%22%3A%222012-10-17%22%2C%22Statement%22%3A%5B%7B%22Sid%22%3A%22%22%2C%22Effect%22%3A%22Allow%22%2C%22Principal%22%3A%7B%22Service%22%3A%22ec2.amazonaws.com%22%7D%2C%22Action%22%3A%22sts%3AAssumeRole%22%7D%5D%7D' }
end


describe iam_policy('policy-dev-describetags') do
  it { should exist }
  it { should be_attachable }
  its(:attachment_count) { should eq 1 }
  it { should be_attached_to_role('role-dev-instance') }
end


describe security_group('sg-dev-bastion') do
  it { should exist }
  it { should belong_to_vpc('vpc-dev') }
  its(:outbound) { should be_opened.protocol('all').for('0.0.0.0/0') }
  its(:inbound) { should be_opened(22).protocol('tcp').for('0.0.0.0/0') }
end


describe ec2('dev-bastion') do
  it { should exist }
  it { should be_running }
  its(:instance_type) { should eq 't2.micro' }
  it { should have_security_group('sg-dev-bastion') }
  it { should belong_to_vpc('vpc-dev') }
  it { should belong_to_subnet('sn-dev-public-1a') }
  it { should have_ebs('dev-bastion') }
  its(:key_name) { should eq 'aws' }
  it { should have_iam_instance_profile('instanceprofile-dev-instance') }
  its(:hypervisor) { should eq 'xen' }
  its(:virtualization_type) { should eq 'hvm' }
end


describe security_group('sg-dev-app-elb') do
  it { should exist }
  it { should belong_to_vpc('vpc-dev') }
  its(:outbound) { should be_opened.protocol('all').for('0.0.0.0/0') }
  its(:inbound) { should be_opened(80).protocol('tcp').for('0.0.0.0/0') }
end


describe elb('elb-dev-app') do
  it { should exist }
  it { should belong_to_vpc('vpc-dev') }
  it { should have_subnet('sn-dev-public-1a') }
  it { should have_subnet('sn-dev-public-1b') }
  it { should have_subnet('sn-dev-public-1c') }
  it { should have_security_group('sg-dev-app-elb') }
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


describe security_group('sg-dev-app') do
  it { should exist }
  it { should belong_to_vpc('vpc-dev') }
  its(:outbound) { should be_opened.protocol('all').for('0.0.0.0/0') }
  its(:inbound) { should be_opened(22).protocol('tcp').for('sg-dev-bastion') }
  its(:inbound) { should be_opened(80).protocol('tcp').for('sg-dev-bastion') }
  its(:inbound) { should be_opened(80).protocol('tcp').for('sg-dev-app-elb') }
end


describe launch_configuration('asglc-dev-app') do
  it { should exist }
  its(:instance_type) { should eq 't2.micro' }
  it { should have_security_group('sg-dev-app') }
  its(:associate_public_ip_address) { should eq nil }
  its(:key_name) { should eq 'aws' }
  its(:iam_instance_profile) { should eq 'instanceprofile-dev-instance' }
end


describe autoscaling_group('asg-dev-app') do
  it { should exist }
  it { should have_launch_configuration('asglc-dev-app') }
  it { should have_elb('elb-dev-app') }
  its(:min_size) { should eq 2 }
  its(:max_size) { should eq 2 }
  its(:desired_capacity) { should eq 2 }
  its(:default_cooldown) { should eq 30 }
  its(:health_check_grace_period) { should eq 60 }
  its(:health_check_type) { should eq 'EC2' }
end
