#!/usr/bin/env bash
set -euo pipefail

export TF_VAR_digitalocean_token=$(pass ls homeserver.setup/secrets/1/do_token)
export TF_VAR_digitalocean_personal_pub_key=$(pass ls homeserver.setup/secrets/1/do_pub_key)
export TF_VAR_digitalocean_droplet_name=$(pass ls homeserver.setup/secrets/1/do_name)
export TF_VAR_digitalocean_base_domain=$(pass ls homeserver.setup/secrets/1/do_base_domain)

setup_infra() {
    terraform -chdir=terraform plan
    terraform -chdir=terraform apply

    export ssh_host_ip=$(terraform output ssh_ip)
    export ssh_pv_key=$(terraform output ssh_pv_key)
    export ssh_host_name=homeserver

    echo -e "\nHost ${ssh_host_name}\n\tUser root\n\tIdentityFile ${ssh_pv_key}\n\tHostName ${ssh_host_ip}" >> ~/.ssh/config
}

setup_software() {
    ansible-galaxy role install --force -r ./ansible/requirements.yml
    ansible-galaxy collection install --force -r ./ansible/requirements.yml
    ansible-playbook -i ./ansible/hosts ./ansible/playbook.yml --verbose
}

setup_infra
setup_software
