
# Terraform bucket creation and Kitchen terraform tests

This repository contains the steps for the test creation of s3 bucket with two files using terraform and the testing of the terraform code using Kitchen.

## Requirements.

**Note:** This was tested in an Ubuntu 18.04 linux distro

1. Install AWS CLI
2. An AWS account profile configured in the system, it can be done with this command
```sh
    $ aws configure
```
3. Install tfenv tool: https://github.com/tfutils/tfenv
```sh
    $ brew install tfenv
```
4. Install Terraform 0.12.9 using tfenv
```sh
    $ tfenv install 0.12.9
```
5. Install Ruby and bundler if not installed
```sh
    $ sudo apt-get install ruby-full
    $ gem install bundler
```

## Terraform code.

The terraform code is simple. A file called s3.tf that contains:

* The AWS region to deploy the s3
* The required version of Terraform
* The resource to create the s3 bucket
* Two resources to create the files with the timestamp of code execution

## Kitchen terraform

To test the terraform code the following steps where made:

1. Created the Gemfile to install dependencies:
```
  source "https://rubygems.org/" do
    gem 'awspec', '~> 1.18.2'
    gem 'kitchen-terraform', '~> 5.1.0'
    gem 'kitchen-verifier-awspec', '~> 0.2.0'
  end
```
2. Install the gems
```sh
    $ sudo bundle install
```
3. Create the directories *test/fixtures/tf_module* and *tet/integration/kt_suite*. 
The first will have the terrafom module that will use the terraform code to test:
```
    module "kt_test" {
    source = "../../.."
    }
```
The second directory will have the ruby script that fill use **Chef Inspec** and Kitchen to test the terraform code.

4. Create the .kitchen.yml file that will connect to the AWS account using as verifier awspec, using as provisioner terraform, and using the ruby script 
```
driver:
  name: terraform
  root_module_directory: test/fixtures/tf_module
  parallelism: 4

provisioner:
  name: terraform

verifier:
  name: awspec

platforms:
  - name: aws

suites:
  - name: "kt_suite"
    verifier:
      patterns:
        - "test/integration/kt_suite/test_s3.rb"
```
5. Create tue ruby script 
```
# frozen_string_literal: true
require 'awspec'

describe s3_bucket('flugel-bucket-test'.to_s) do
    it { should exist }
 #   it { should_not be_public }
end

describe s3_bucket_object(bucket_name: 'flugel-bucket-test', key: 'test1') do
    it { should exist }
  #  it { should_not be_public }
end

describe s3_bucket_object(bucket_name: 'flugel-bucket-test', key: 'test2') do
    it { should exist }
  #  it { should_not be_public }
end
```

## Validation

Once all this is configured, the terraform code will be planned, applyed, verfyed and tested using this command:
```sh
    bundle exec kitchen test
```

**Note:** being honest there is an error running the ruby tests, because in Chef Inspec documentation there are resources called aws_s3_bucket and aws_s3_bucket_object, but when I use that resources I get error of this type:
```sh
  NoMethodError:
  undefined method `s3_bucket_object' for main:Object
  Did you mean?  s3_bucket
  # ./test/integration/kt_suite/test_s3.rb:9:in `<top (required)>'

```
So, I deliver the code with one test working because I used the suggestion made in the error.