# frozen_string_literal: true
require 'awspec'

describe s3_bucket('flugel-bucket-test'.to_s) do
    it { should exist }
 #   it { should_not be_public }
end

describe s3_bucket(bucket_name: 'flugel-bucket-test', key: 'test1') do
    it { should exist }
  #  it { should_not be_public }
end

describe s3_bucket(bucket_name: 'flugel-bucket-test', key: 'test2') do
    it { should exist }
  #  it { should_not be_public }
end