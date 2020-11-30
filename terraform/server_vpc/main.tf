provider "aws" {
  region = "us-east-2"
}

module "custom_vpc" {
  source      = "../modules/vpc"
  vpc_id      = module.custom_vpc.vpc_id
  vpc_cidr    = "192.168.0.0/16"
  tenancy     = "default"
  subnet_cidr = "192.168.1.0/24"
  #map_public_ip_on_launch = "true"
}


module "instance" {
  source         = "../modules/ec2_vpc/"
  KeyName        = "jenkins1"
  InstanceType   = "t2.micro"
  #ImageId        = "ami-06b263d6ceff0b3dd"
  ImageId         = "ami-0e82959d4ed12de3f"
  instance_count = "2"
  subnet_id      = module.custom_vpc.subnet_id
  AnsibleDir     = "../../project_ansible_playbooks/jenkins"
  #associate_public_ip_address = "true"
}