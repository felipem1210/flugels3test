module "networking" {   
  source = "./modules/networking"   
  azs_list = ["us-west-2a"]   
  cidr_block = "192.168.0.0/16"
  newbits = 4   
  tags = {
    Name   = "flugel"
    Environment = "dev"
    prefix      = "test"
  }
}
