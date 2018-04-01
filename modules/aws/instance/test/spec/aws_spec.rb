require 'spec_helper'


# Set minimum length before truncation occurs in reports.
RSpec::Support::ObjectFormatter.default_instance.max_formatted_output_length =
  1024


describe security_group('sg-unittest-instance-single') do
  it { should exist }
  it { should belong_to_vpc('vpc-unittest-instance') }
  its(:outbound) { should be_opened.protocol('all').for('0.0.0.0/0') }
end


describe ec2('unittest-instance-single1') do
  it { should exist }
  it { should be_running }
  its(:instance_type) { should eq 't2.micro' }
  it { should have_security_group('sg-unittest-instance-single') }
  it { should have_security_group('sg-unittest-instance-all') }
  it { should belong_to_vpc('vpc-unittest-instance') }
  it { should belong_to_subnet('sn-unittest-instance-public-1a') }
  it { should have_ebs('unittest-instance-single1') }
  its(:key_name) { should eq 'aws' }
  it { should have_iam_instance_profile('instanceprofile-unittest-instance') }
  its(:hypervisor) { should eq 'xen' }
  its(:virtualization_type) { should eq 'hvm' }
end


describe security_group('sg-unittest-instance-multiple') do
  it { should exist }
  it { should belong_to_vpc('vpc-unittest-instance') }
  its(:outbound) { should be_opened.protocol('all').for('0.0.0.0/0') }
end


describe ec2('unittest-instance-multiple1') do
  it { should exist }
  it { should be_running }
  its(:instance_type) { should eq 't2.micro' }
  it { should have_security_group('sg-unittest-instance-multiple') }
  it { should have_security_group('sg-unittest-instance-all') }
  it { should belong_to_vpc('vpc-unittest-instance') }
  it { should belong_to_subnet('sn-unittest-instance-public-1a') }
  it { should have_ebs('unittest-instance-multiple1') }
  its(:key_name) { should eq 'aws' }
  it { should have_iam_instance_profile('instanceprofile-unittest-instance') }
  its(:hypervisor) { should eq 'xen' }
  its(:virtualization_type) { should eq 'hvm' }
end


describe ec2('unittest-instance-multiple2') do
  it { should exist }
  it { should be_running }
  its(:instance_type) { should eq 't2.micro' }
  it { should have_security_group('sg-unittest-instance-multiple') }
  it { should have_security_group('sg-unittest-instance-all') }
  it { should belong_to_vpc('vpc-unittest-instance') }
  it { should belong_to_subnet('sn-unittest-instance-public-1b') }
  it { should have_ebs('unittest-instance-multiple2') }
  its(:key_name) { should eq 'aws' }
  it { should have_iam_instance_profile('instanceprofile-unittest-instance') }
  its(:hypervisor) { should eq 'xen' }
  its(:virtualization_type) { should eq 'hvm' }
end
