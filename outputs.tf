#------ root/outputs

output "public_ip" {
  value = module.compute.public_ip
}

output "id" {
  value = module.compute.id
}

