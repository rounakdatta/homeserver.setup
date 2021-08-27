provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "digitalocean_ssh_key" "pubs" {
  name = "personal_pub_key"
  public_key = file("${var.digitalocean_personal_pub_key}")
}

resource "digitalocean_droplet" "drops" {
  name = "${var.digitalocean_droplet_name}"
  size = "s-1vcpu-1gb"
  region = "blr1"
  image = "ubuntu-20-04-x64"
  ssh_keys = [ "${digitalocean_ssh_key.pubs.id}" ]
}

resource "digitalocean_domain" "doms" {
  name = "${digitalocean_droplet.drops.name}.${var.digitalocean_base_domain}"
  ip_address = "${digitalocean_droplet.drops.ipv4_address}"
}

resource "digitalocean_record" "recssl" {
  domain = "${digitalocean_domain.doms.name}"
  type = "CAA"
  name = "@"
  value = "letsencrypt.org"
  tag = "issue"
  flags = 0
}

output "ssh_ip" {
  value = "${digitalocean_droplet.drops.ipv4_address}"
}
