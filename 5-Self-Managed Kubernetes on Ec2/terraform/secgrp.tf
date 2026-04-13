data "http" "my_public_ip" {
  url = "http://checkip.amazonaws.com/"
}

locals {
  # Use chomp() to remove any trailing newlines or whitespace
  my_public_ip_cidr = "${chomp(data.http.my_public_ip.response_body)}/32"
}

#####------------------------------------------------------------------------------------------------------------------

### Security Group for the Docker EC2 Instance

resource "aws_security_group" "Docker-SG" {
  name        = "Docker-sg"
  description = "Allow SSH and HTTP inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "Docker-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_docker" {
  security_group_id = aws_security_group.Docker-SG.id
  cidr_ipv4         = local.my_public_ip_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_docker" {
  security_group_id = aws_security_group.Docker-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_docker" {
  security_group_id = aws_security_group.Docker-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

