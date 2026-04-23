resource "aws_ebs_volume" "db-volume" {
  availability_zone = var.AWS_Zone-a
  size              = 2

  tags = {
    Name = "db-volume"
  }
}

## Attach EBS Volume to EC2 Instance

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.db-volume.id
  instance_id = module.ec2_instance_k8s.id
}