variable "password" {
  type = string
  description = "It's the password, should be length of +16 chars."
  validation {
    condition     = ("" == var.password || length(var.password) <= 15)? false : true
    error_message = "Password cannot be null and needs to be bigger than +16 chars."
  }
}