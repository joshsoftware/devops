resource "aws_instance" "ec2" {
  count         = var.instance_count
  ami           = var.ImageId
  instance_type = var.InstanceType
  key_name      = var.KeyName
  subnet_id     = var.subnet_id
  #associate_public_ip_address = var.instance_ip
  tags = {
    Name = "Terraform_Test1"
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file("/home/krish/.ssh/id_rsa")
  }

  provisioner "remote-exec" {

    inline = [
      "pwd"
    ]
  }


}
resource "null_resource" "ansible-deploy" {


  provisioner "local-exec" {
    command = <<EOF
    export ANSIBLE_HOST_KEY_CHECKING=False; sleep 100; cd ${var.AnsibleDir} ; ansible-playbook -i inventory sites.yml --extra-vars "@vars.yml" --sudo -vv
    EOF
    #    command = "export ANSIBLE_HOST_KEY_CHECKING=False; sleep 100; cd ${var.AnsibleDir} ; ansible-playbook -i inventory sites.yml --extra-vars '@vars.yml' --sudo -vv"

  }
  depends_on = [aws_instance.ec2]
}
#provisioner "local-exec" {
#  command = "echo The servers IP address is ${self.public_ip}"
#}
