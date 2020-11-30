resource "aws_vpc" "custom" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.tenancy

  tags = {
    Name = "custom"
  }
}

resource "aws_subnet" "custom" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = var.ip

  tags = {
    Name = "custom_subnet"
  }tolist(data.aws_subnet_ids.all.ids)
}

output "vpc_id" {
  value = aws_vpc.custom.id
}

output "subnet_id" {
  value = aws_subnet.custom.id
}


