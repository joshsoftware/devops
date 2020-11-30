/*
data "aws_subnet_ids" "subnets" {
  vpc_id = "vpc-347c4d4e"
}

data "aws_subnet" "subnet" {
  count = length(data.aws_subnet_ids.subnets.ids)
  id = element(tolist(data.aws_subnet_ids.subnets.ids), count.index)
  #id = element(data.aws_subnet_ids.subnets.ids, count.index)
}

output "subnet_cidr_blocks" {
  value = data.aws_subnet.subnet.*.id
}
*/
/*
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "subnets" {
  vpc_id = "vpc-347c4d4e"
}
data "aws_subnet_ids" "all" {
  #count = length(data.aws_vpc.default.id)
  #vpc_id = tolist(element(data.aws_vpc.default.id, count.index))
  #vpc_id = tolist(element(data.aws_vpc.default.id, count.index))
  vpc_id = data.aws_vpc.default.id
}
*/
/*
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

output "subnet_id" {
  value = data.aws_subnet_ids
}
*/


resource "aws_instance" "ec2" {
  count     = var.instance_count
  user_data = <<EOF
#!/bin/bash
sudo mkdir /www
sudo cp /etc/fstab /etc/fstab.bak
sudo su -
echo "/dev/xvdb       /www   ext4    defaults        0 2" >> /etc/fstab
mount -a
EOF
  #availability_zone = "us-east-1"
  root_block_device {
    volume_size = var.root_volume
  }
  ami           = var.ImageId
  instance_type = var.InstanceType
  key_name      = var.KeyName
  subnet_id     = var.subnet_id

  tags = {
    Name = "${var.name}-${count.index + 1}"
  }

  /*
  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file("/home/krish/.ssh/id_rsa")
  }

  provisioner "remote-exec" {

    inline = [
      "sudo mount -a"
    ]

  }
*/

}


resource "aws_ebs_volume" "volume" {
  count             = var.instance_count
  availability_zone = aws_instance.ec2[count.index].availability_zone
  type              = var.type
  size              = var.size
  tags = {
    Name = "${var.name}-${count.index + 1}-${var.type}-Volume"
  }
}

resource "aws_volume_attachment" "volume-attachment" {
  device_name  = "/dev/xvdb"
  count        = var.instance_count
  instance_id  = aws_instance.ec2[count.index].id
  volume_id    = aws_ebs_volume.volume[count.index].id
  force_detach = true

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.ec2[count.index].public_ip
    private_key = file("/home/krish/.ssh/id_rsa")
    agent       = false
  }

  provisioner "remote-exec" {

    inline = [
      "sudo mkfs -t ext4 /dev/xvdb",
      "sudo mount -a"
    ]

  }
  depends_on = [aws_instance.ec2]
}

/*
resource "null_resource" "ansible-deploy" {


  provisioner "local-exec" {
    command = <<EOF
    sleep 100; cd ${var.AnsibleDir} ; ansible-playbook -i inventory sites.yml --extra-vars "@vars.yml" -b -vv
    EOF
    #    command = "export ANSIBLE_HOST_KEY_CHECKING=False; sleep 100; cd ${var.AnsibleDir} ; ansible-playbook -i inventory sites.yml --extra-vars '@vars.yml' --sudo -vv"

  }
  depends_on = [aws_instance.ec2, aws_volume_attachment.volume-attachment]
}
*/
#provisioner "local-exec" {
#  command = "echo The servers IP address is ${self.public_ip}"
#}


/*data "aws_vpc" "default" {
  default = true
}*/

data "aws_subnet_ids" "all" {
  #vpc_id = data.aws_vpc.default.id
  vpc_id = "vpc-347c4d4e"
}

output "subnet_ids" {
  value = data.aws_subnet_ids.all.ids
}