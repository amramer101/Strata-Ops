resource "aws_key_pair" "k8s_Key_Pair" {
  key_name   = "k8s_Key_Pair"
  public_key = file(var.Pub_Key_Path)
}
