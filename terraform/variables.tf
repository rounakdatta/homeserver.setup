variable "digitalocean_token" {
  type = string
  description = "Token to associate and authorize account with"
}

variable "digitalocean_personal_pub_key" {
  type = string
  description = "Local path to the SSH public key to bake the instance with"
}

variable "digitalocean_droplet_name" {
  type = string
  description = "Name for the droplet - also becomes the subdomain"
}

variable "digitalocean_base_domain" {
  type = string
  description = "Base domain"
}
