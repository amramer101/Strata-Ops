resource "aws_key_pair" "docker_Key_Pair" {
  key_name   = "docker_Key_Pair"
  public_key = file(var.Pub_Key_Path)
}
