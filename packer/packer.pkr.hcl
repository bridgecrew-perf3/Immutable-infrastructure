source "amazon-ebs" "base-ami" {
  ami_name                    = "packer-base"
  instance_type               = "t2.micro"
  region                      = "us-east-2" 
  shared_credentials_file = "~/.aws/credentials"
  force_deregister = true
  force_delete_snapshot = true
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type = "ebs"
    }
    owners = ["099720109477"]
    most_recent = true

  }
  ssh_username = "ubuntu"
  ssh_timeout = "30s"
  tags = {
    Name = "Packer-Ansible"
  }
}

build {
  sources = ["source.amazon-ebs.base-ami"]

  provisioner "ansible" {
    playbook_file = "../ansible/playbook.yml"
  }

}
