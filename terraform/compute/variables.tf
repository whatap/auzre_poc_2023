variable "resource_group_location" {
  type        = string
  default     = "koreacentral"
  description = "Daelim POC."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "daelimrg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}


variable "hsnamPubKey"{
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDM/V4/qU9eTifaLdBPnwS7r0moYq5fgRelFCgit71GNLghtalfwdviiKt19v3JBQWZcmlw4D6JshIQ2bpe0g4GhHLUY7QdFWlgWfCLRAI/oaENLUW4Dg0wRfSPU9VpZq30SIAjdERUy2gb2Ym2/wyohqQ21I9SrixJ6eyrUo/PvVvZYqZ6RfvST1wkTGLpA2iYOCbAoIrWdeOWs45FB4r/LOmK4LUAWUhk4KbsCausem72gfj54OkpnRmCCcUW38hJR1+BZAVQWp3DNnJhJxhICCiQf+jdyOgo+TYfI84DtUr2vaNinIUr3SaAFVcOMe3WR981YrljqPqE5nrhmAB7 hsnam@hsnam-VirtualBox"
}


variable "petclinic_db_user"{
  default = "petclinic"  
}

variable "petclinic_db_passed"{
  default = "petclinic"
}

variable "subnet_start"{
  default = "10.0.1.0"
}

variable "subnet_end"{
  default = "10.0.2.255"
}

variable "mysqladminloginuser"{
  default = "mysqladminun"
}

variable "mysqladminloginpasswd"{
  default = "H@Sh1CoR3!"
}