variable "KeyName" {
  type    = string
  default = ""
}

variable "InstanceType" {
  type    = string
  default = "t2.micro"
}

variable "ImageId" {
  type    = string
  default = "ami-06b263d6ceff0b3dd"
}

variable "instance_count" {
  default = "2"
}

variable "AnsibleDir" {
  type    = string
  default = "../project_ansible_playbooks/jenkins/"
}

variable "subnet_id" {}

variable "instance_ip" {
  default = "true"
}
