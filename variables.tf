variable "region" {
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  type        = map
  default = {
    Project     = "Quiz"
    Environment = "dev"
  }
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
}



variable "ports" {
  type        = list
  default     = ["80", "22"]
}