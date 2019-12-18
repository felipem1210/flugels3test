provider "aws" {
  region = "us-west-1"
  version = "2.30"
}

terraform {
  required_version = " ~> 0.12.9 "
}

resource "aws_s3_bucket" "test" {
  bucket = "flugel-bucket-test"
  region = "us-west-1"
  acl    = "private"
  force_destroy = "true"

  tags = {
    Name        = "Files bucket"
    Environment = "Test"
  }
}

resource "aws_s3_bucket_object" "file1" {
  bucket = aws_s3_bucket.test.id
  key    = "test1"
  #source = "test1.txt"
  content = timestamp()
}

resource "aws_s3_bucket_object" "file2" {
  bucket = aws_s3_bucket.test.id
  key    = "test2"
  #source = "test2.txt"
  content = timestamp()
}

