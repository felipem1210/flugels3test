module "networking" {   
  source = "github.com/felipem1210/networking.git"   
  azs_list = ["us-west-2a"]   
  cidr_block = "192.168.0.0/16"
  newbits = 4   
  tags = {
    Name   = "flugel"
    Environment = "dev"
    prefix      = "test"
  }
}
