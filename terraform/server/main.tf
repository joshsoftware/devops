


/*


locals {
  map1 = {
    name1 = "subnet-24bf5a42"
    name2 = "subnet-372bcd68"
  }
}

*/

provider "aws" {
  region = "us-east-1"
}

module "instance" {
  source       = "../modules/ec2/"
  name         = "Instance"
  KeyName      = "jenkins1"
  InstanceType = "t2.micro"
  #(Ubuntu 18)ImageId      = "ami-06b263d6ceff0b3dd"
  ImageId = "ami-0dba2cb6798deb6d8"
  #(Ubuntu 16)ImageId       = "ami-0f82752aa17ff8f5d"
  instance_count = "1"
  AnsibleDir     = "../../project_ansible_playbooks/jenkins"
  type           = "gp2"
  size           = "2"
  root_volume    = "10"
  #subnet_id      = "subnet-24bf5a42"
  subnet_id = tolist(module.instance.subnet_ids)[0]
}