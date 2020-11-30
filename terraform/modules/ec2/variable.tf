variable "name" {
  default = "Instance"
}
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

variable "size" {
  default     = "2"
  description = "Size of EBS volume."
}

variable "type" {
  default     = "gp2"
  description = "Type of EBS volume."
}

variable "root_volume" {
  default     = "15"
  description = "Size of ec2 root volume."
}

variable "subnet_id" {
  type        = string
  description = "Resource Subnet ID"
}

/*
variable "subnet_ids" {
    type = list(string)
    description = "Resource Subnet ID"
}

variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(map(string))
  default     = []
}
*/