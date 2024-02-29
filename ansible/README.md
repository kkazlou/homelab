## Usefull ad hoc commands

```
ansible -m ping pve03
ansible -b -m ping pve03
ansible -b -m reboot pve03
```

## Running Playbooks

* Limit the playbook to specific host or group.
* List hosts, don't run the actual playbook.
```
ansible-playbook update-all-packages.yml --limit "proxmox" --list-hosts
```

## References 
* [Introduction to ad hoc commands](https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html)
* [Patterns: targeting hosts and groups](https://docs.ansible.com/ansible/latest/inventory_guide/intro_patterns.html)