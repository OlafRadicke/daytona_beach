
output "hello_world" {
  value = "Hello ${var.user_name}"
}

output "show_password" {
  value = "My password is: ${var.user_password}"
}