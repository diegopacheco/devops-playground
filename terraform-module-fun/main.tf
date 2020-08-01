module "hash-module" {
  source = "./hash-module"
  //password = "secret" // Error: Invalid value for variable
  password = "this_is_my_secret_password1!"
}
output "hashed_pass_result" {
  value = "${module.hash-module.pass_hash}"
}