resource "null_resource" "default" {
  provisioner "local-exec" {
    command = "echo 'Hello ${var.user_name}'"
  }
}

output "hello_world" {
  value = "Hello ${var.user_name}"
}