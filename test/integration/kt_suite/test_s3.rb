# frozen_string_literal: true
require 'awspec'

describe s3_bucket('flugel-bucket-test'.to_s) do
    it { should exist }
    it { should have_object('test1') }
    it { should have_object('test2') }
 #   it { should_not be_public }
end

describe ec2('flugel') do
  it { should exist }
end

