variable "binarylane_email" {
  description = "Email Address/User used to login to the BinaryLane api."
  default = "default email"
}

variable "binarylane_api_key" {
  description = "API key used to login/verify for APIs used at binarylane."
  default = "default key"
}

variable "ssh_key" {
  description = "The PUBLIC SSH key you want to use to access your VPSs."
  default = "default key"
}
