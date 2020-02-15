# Variable for key pair
variable "key_name" {
  description = "Unique name for the key, should also be a valid filename. This will prefix the public/private key."
  default = "ec2-key-terraform" # in our case!
}

variable "path" {
  description = "Path to a directory where the public and private key will be stored."
  default     = ""
}