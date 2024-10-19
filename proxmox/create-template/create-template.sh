#!/bin/bash

# Create template
# args:
#  vm_id
#  vm_name
#  file name in the current directory

function create_template() {

    # Delete VM if it exists
    echo "Deleting VM $1"
    qm destroy $1

    # Create a VM with specific name, OS type, amount of memory and CPU cores
    echo "Creating VM $1 ($2)"
    qm create $1 --name $2 --ostype l26
    qm set $1 --memory 4096 --cores 2 --cpu host

    # Configure SCSI drive
    qm set $1 --scsihw virtio-scsi-single
    #qm disk import $1 $3 ${storage} --format qcow2
    #qm set $1 --scsi0 ${storage}:$1/vm-$1-disk-0.qcow2,discard=on,iothread=1
    qm set $1 --scsi0 ${storage}:0,import-from="$(pwd)/$3",discard=on,iothread=1
    qm resize $1 scsi0 32G

    # Configure other oprions
    qm set $1 --boot order=scsi0
    qm set $1 --serial0 socket --vga serial0
    qm set $1 --net0 virtio,bridge=vmbr0
    qm set $1 --agent enabled=1,fstrim_cloned_disks=1

    # Confugure cloud-init
    qm set $1 --ide2 ${storage}:cloudinit
    qm set $1 --ciuser ${username}
    #qm set $1 --cipassword password
    qm set $1 --sshkeys ${ssh_public_key}
    qm set $1 --ipconfig0 ip=dhcp

    # Convert VM into a template
    echo Converting VM $1 into a template
    qm template $1

    # Remove file when done
    #rm $3
}

# Name of your Proxmox storage
#export storage=nfs-fast
export storage=local-lvm

# Username to create on VM template
export username=ansible

# Path to SSH public key
export ssh_public_key=ansible.pub

# Ubuntu Server 24.04 LTS (Noble Numbat)
wget --continue "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
create_template 900 "template-ubuntu-24.04-server-cloud" "noble-server-cloudimg-amd64.img"

# Ubuntu Minimal 24.04 LTS (Noble Numbat)
wget --continue "https://cloud-images.ubuntu.com/minimal/releases/noble/release/ubuntu-24.04-minimal-cloudimg-amd64.img"
create_template 901 "template-ubuntu-24.04-minimal-cloud" "ubuntu-24.04-minimal-cloudimg-amd64.img"

# Debian 12 (Bookworm)
wget --continue "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
create_template 910 "template-debian-12-cloud" "debian-12-genericcloud-amd64.qcow2"

# Fedora 40
wget --continue "https://download.fedoraproject.org/pub/fedora/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-Generic.x86_64-40-1.14.qcow2"
create_template 920 "template-fedora-40-cloud" "Fedora-Cloud-Base-Generic.x86_64-40-1.14.qcow2"
