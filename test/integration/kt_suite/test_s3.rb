# frozen_string_literal: true
require 'awspec'
require 'aws-sdk'
require 'net/http'

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
            for i in 1..2
                url = 'http://' + public_ip + "/test#{i}"
                uri = URI(url)
                res = Net::HTTP.get_response(uri)
                code = res.code
                if code == "200"
                    puts "SUCCESS: the URL #{url} is valid and working"
                else
                    abort("ERROR: the URL #{url} is not working or is invalid ")
                end
            end
        end
    end
end
