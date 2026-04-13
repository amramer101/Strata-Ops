## search for ubuntu22 ami 

data "aws_ami" "ubuntu22" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


##--------------------------------------------------------------------------------------------------------------

### EC2 Instance for Docker Server

module "ec2_instance_docker" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "Docker-instance"

  instance_type               = "t2.medium"
  associate_public_ip_address = true
  ami                         = data.aws_ami.ubuntu22.id
  vpc_security_group_ids      = [aws_security_group.Docker-SG.id]
  key_name                    = aws_key_pair.docker_Key_Pair.key_name
  monitoring                  = false
  subnet_id                   = module.vpc.public_subnets[0]
  create_security_group       = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}

resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory.ini"
  content  = <<-EOF
    [docker_server]
    ${module.ec2_instance_docker.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=../terraform/docker-key
    
    [docker_server:vars]
    ansible_ssh_common_args='-o StrictHostKeyChecking=no'
  EOF
}