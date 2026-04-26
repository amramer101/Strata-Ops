data "http" "my_public_ip" {
  url = "http://checkip.amazonaws.com/"
}

locals {
  # Use chomp() to remove any trailing newlines or whitespace
  my_public_ip_cidr = "${chomp(data.http.my_public_ip.response_body)}/32"
}



####---------------------------------------------------------------------------------------------

### Security Group for the Data Resources (RDS, RabbitMQ, ElastiCache)

resource "aws_security_group" "Data-SG" {
  name        = "Data-SG"
  description = "Allow 3306, 11211, 5672 inbound traffic from tomcat and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "Data-SG"
  }
}

## Database SG (MySQL)

## For Node
resource "aws_vpc_security_group_ingress_rule" "allow_3306_from_node_sg" {
  security_group_id            = aws_security_group.Data-SG.id
  referenced_security_group_id = module.eks.node_security_group_id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}
## For pods
resource "aws_vpc_security_group_ingress_rule" "allow_3306_from_cluster_sg" {
  security_group_id            = aws_security_group.Data-SG.id
  referenced_security_group_id = module.eks.cluster_primary_security_group_id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}

## Memcached SG (11211) ---------------------------------------------------------
## For Node
resource "aws_vpc_security_group_ingress_rule" "allow_11211_from_node_sg" {
  security_group_id            = aws_security_group.Data-SG.id
  referenced_security_group_id = module.eks.node_security_group_id
  from_port                    = 11211
  ip_protocol                  = "tcp"
  to_port                      = 11211
}
## For pods
resource "aws_vpc_security_group_ingress_rule" "allow_11211_from_cluster_sg" {
  security_group_id            = aws_security_group.Data-SG.id
  referenced_security_group_id = module.eks.cluster_primary_security_group_id
  from_port                    = 11211
  ip_protocol                  = "tcp"
  to_port                      = 11211
}


## RabbitMQ SG (5672 for AMQP, 5671 for AMQPS) ------------------------------------
## For Node
resource "aws_vpc_security_group_ingress_rule" "allow_5671_from_node_sg" {
  security_group_id            = aws_security_group.Data-SG.id
  referenced_security_group_id = module.eks.node_security_group_id
  from_port                    = 5671
  ip_protocol                  = "tcp"
  to_port                      = 5671
}
resource "aws_vpc_security_group_ingress_rule" "allow_5672_from_node_sg" {
  security_group_id            = aws_security_group.Data-SG.id
  referenced_security_group_id = module.eks.node_security_group_id
  from_port                    = 5672
  ip_protocol                  = "tcp"
  to_port                      = 5672
}

## For pods
resource "aws_vpc_security_group_ingress_rule" "allow_5671_from_cluster_sg" {
  security_group_id            = aws_security_group.Data-SG.id
  referenced_security_group_id = module.eks.cluster_primary_security_group_id
  from_port                    = 5671
  ip_protocol                  = "tcp"
  to_port                      = 5671
}
resource "aws_vpc_security_group_ingress_rule" "allow_5672_from_cluster_sg" {
  security_group_id            = aws_security_group.Data-SG.id
  referenced_security_group_id = module.eks.cluster_primary_security_group_id
  from_port                    = 5672
  ip_protocol                  = "tcp"
  to_port                      = 5672
}

## Egress rule to allow all outbound traffic from the Data-SG
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_Data" {
  security_group_id = aws_security_group.Data-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

## Additional rules to allow access from the Bastion SG to the Data SG (for RDS MySQL)
resource "aws_vpc_security_group_ingress_rule" "allow_3306_from_Bastion" {
  security_group_id            = aws_security_group.Data-SG.id
  referenced_security_group_id = aws_security_group.Bastion-SG.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}

## Allow all traffic between Data-SG members (for RDS, RabbitMQ, ElastiCache to talk to each other if needed)
resource "aws_vpc_security_group_ingress_rule" "allow_ipv4_internal" {
  security_group_id            = aws_security_group.Data-SG.id
  referenced_security_group_id = aws_security_group.Data-SG.id
  from_port                    = 0
  ip_protocol                  = "tcp"
  to_port                      = 65535
}

####---------------------------------------------------------------------------------------------

### Security Group for the Bastion EC2s Instance

resource "aws_security_group" "Bastion-SG" {
  name        = "Bastion-SG"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "Bastion-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_Bastion" {
  security_group_id = aws_security_group.Bastion-SG.id
  cidr_ipv4         = local.my_public_ip_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_Bastion" {
  security_group_id = aws_security_group.Bastion-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



