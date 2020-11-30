### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      instance-dns = aws_instance.ec2.*.public_dns,
      instance-ip  = aws_instance.ec2.*.public_ip,
      instance-id  = aws_instance.ec2.*.id
    }
  )
  filename = "../../project_ansible_playbooks/jenkins/inventory"
}