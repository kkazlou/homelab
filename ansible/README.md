# Ansible

## Usefull ad hoc commands

```
ansible -m ping host1
ansible -b -m ping host1
ansible -b -m reboot host1
```
Reboot one host at a time.
```
ansible -b -m reboot --forks 1 group1
```

## Running Playbooks

Install required collections first.
```
ansible-galaxy collection install -r requirements.yml
```

List hosts, don't run the actual playbook.
```
ansible-playbook update-all-packages.yml --list-hosts
```

Limit a playbook to the specific host or group.
```
ansible-playbook update-all-packages.yml --limit group1
```

## Secrets

Secrets are stored with ansible-vault in `inventory/group_vars/*/vault.yml`. The vault password
is read from `~/.ansible/homelab-vault-pass` (see `ansible.cfg`); keep a backup of it outside
this repo.
```
ansible-vault view inventory/group_vars/docker/vault.yml
ansible-vault edit inventory/group_vars/docker/vault.yml
```


## UPS shutdown (NUT)

An APC Smart-UPS 750 is connected over USB to pihole02, which runs the NUT server.
During a power outage, devices shut down in this order:

| Time on battery | What happens |
|---|---|
| 5 min | Proxmox nodes shut down (NUT clients, `upssched` timer on each node) |
| 5 min | pihole02 powers off the UNAS Pro over SSH |
| Low battery (5 min runtime left) | The Synology shuts down (NUT client in DSM). pihole02 powers off the UNAS again if needed, then the UDM-Pro, then itself |

```
ansible-playbook install-nut-server.yml   # pihole02: NUT server, UNAS/UDM shutdown
ansible-playbook install-nut-client.yml   # Proxmox nodes
```

Shutdown decisions from every host:
```
ansible nut_server:nut_client -b -m shell -a 'journalctl -t upssched-cmd -t nut-remote -t nut-monitor --since today --no-pager'
```

Nothing powers the hosts back on: after an outage, start the Proxmox nodes, UNAS
and UDM-Pro by hand.

### Synology (NUT client in DSM)
In Control Panel > Hardware & Power > UPS: enable UPS support, type Synology UPS
server, server IP `192.168.2.12`. Set the time before safe mode to wait until low
battery, so the NAS stays up after the Proxmox nodes are off. DSM always connects as
`monuser`, password `secret`, to UPS `ups`; `upsd.users` keeps that account for it.

### UNAS Pro and UDM-Pro (SSH)
UniFi devices can't run NUT, so pihole02 powers them off over SSH as the `nut` user,
with one key per device (`nut_remote_hosts` in `inventory/group_vars/nut_server/vars.yml`).
Private keys are not in this repo. To set up a device (or redo it after a UniFi
update or reset), for example the UDM-Pro:

1. Enable SSH on the device in the UniFi console.
2. Generate a key on your machine, without a passphrase (it runs unattended):
   ```
   ssh-keygen -t ed25519 -N '' -C nut@pihole02-udm -f udm_ed25519
   ```
3. Copy the private key to pihole02, owned by `nut`, mode `0400`, then delete the local copy:
   ```
   scp udm_ed25519 pihole02:/tmp/ && ssh pihole02 'sudo install -o nut -g nut -m 0400 /tmp/udm_ed25519 /etc/nut/ssh/ && rm /tmp/udm_ed25519'
   ```
4. On the device, install [files/nut/nut-ssh-cmd.sh](files/nut/nut-ssh-cmd.sh) as
   `/root/nut-ssh-cmd.sh` (mode `0755`). To test safely first, replace
   `/sbin/poweroff` with `date`.
5. Add the public key (`udm_ed25519.pub`) to `/root/.ssh/authorized_keys` on the device:
   ```
   restrict,from="192.168.2.12",command="/root/nut-ssh-cmd.sh" ssh-ed25519 AAAA... nut@pihole02-udm
   ```
6. Check the device's host key fingerprint (`ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub`
   on the device) and put the public host key in `nut_remote_hosts`.
7. Run `install-nut-server.yml`. It fails unless each device answers `check` with `ok`.

## References
* [Ansible Documentation / Installation Guide](https://docs.ansible.com/ansible/latest/index.html)
* [Ansible Documentation / Introduction to ad hoc commands](https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html)
* [Ansible Documentation / Patterns: targeting hosts and groups](https://docs.ansible.com/ansible/latest/inventory_guide/intro_patterns.html)
* [Inventory file](inventory/hosts)