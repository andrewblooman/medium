variable "bucket_name" {
    type = string
}

variable "bucket_tags" {
 type = object({
  Project = string
  Creator = string
  Team = string
 }) 
}

variable "encryption_type"{
    type = string
}

variable "subnet_cidr_block" {
  type = string
}