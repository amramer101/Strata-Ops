resource "aws_key_pair" "EC2_Key_Pair" {
  key_name   = "EC2_Key_Pair"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuv4J9xYFlPZqdfrQf5qCUKQ5Mx6Wk79KwTgSX4RZxv amr@JOJO"
}