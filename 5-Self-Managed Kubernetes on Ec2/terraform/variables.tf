variable "AWS_Region" {
  default = "eu-central-1"
}

variable "VPC_Name" {
  default = "Eprofile-VPC-k8s"
}

variable "VPC_CIDR" {
  default = "10.0.0.0/16"
}

variable "Public_Subnet_CIDR" {
  default = ["10.0.0.0/24"]
}

variable "AWS_Zone-a" {
  default = "eu-central-1a"
}

####  Key Pair Variables

variable "Pub_Key_Path" {
  default = "k8s-key.pub"
}


