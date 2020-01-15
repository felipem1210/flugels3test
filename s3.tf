provider "aws" {
  region = "us-west-2"
  version = "2.30"
}

terraform {
  required_version = " ~> 0.12.9 "
}

resource "aws_s3_bucket" "test" {
  bucket = "flugel-bucket-test"
  region = "us-west-2"
  acl    = "public-read"
  force_destroy = "true"

  tags = {
    Name        = "Files bucket"
    Environment = "Test"
  }
}

resource "aws_s3_bucket_object" "file1" {
  bucket = aws_s3_bucket.test.id
  key    = "test1"
  acl    = "public-read"
  content = timestamp()
}

resource "aws_s3_bucket_object" "file2" {
  acl    = "public-read"
  bucket = aws_s3_bucket.test.id
  key    = "test2"
  content = timestamp()
}

