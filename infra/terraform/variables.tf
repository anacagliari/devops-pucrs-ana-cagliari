variable "aws_region" {
  description = "Regiao da AWS"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "ID da AMI Amazon Linux 2"
  type        = string
  default     = "ami-0157af9aea2eef346"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Nome do Key Pair para acesso SSH"
  type        = string
}
