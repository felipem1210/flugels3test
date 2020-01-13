# frozen_string_literal: true
require 'awspec'
require 'aws-sdk'
require 'serverspec'

set :backend, :exec
   
describe s3_bucket('flugel-bucket-test') do
    it { should exist }
    it { should have_object('test1') }
    it { should have_object('test2') }
end

ec2 = Aws::EC2::Client.new
eresp = ec2.describe_instances
eresp[:reservations].each do |reservation|
    reservation[:instances].each do |instance|
        public_ip = instance[:public_ip_address]
        unless public_ip.nil? 
            describe command('cd /var/tmp/ && wget http://' + public_ip + '/test1') do
                its(:exit_status) { should eq 0 }
            end
            describe command('cd /var/tmp/ && wget http://' + public_ip + '/test2') do
                its(:exit_status) { should eq 0 }
            end
        end
    end
end
