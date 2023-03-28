variable "aws_region" {
  description = "AWS region."

  type    = string
  default = "eu-central-1"
}


variable "raw_bucket_name" {
  description = "Name of the bucket containing the raw photos."

  type    = string
  default = "raw-photos-enamya"
}

variable "processed_bucket_name" {
  description = "Name of the bucket containing the processed photos."

  type    = string
  default = "processed-photos-enamya"
}

variable "code_bucket_name" {
  description = "Name of the bucket containing the code."

  type    = string
  default = "code-enamya"
}