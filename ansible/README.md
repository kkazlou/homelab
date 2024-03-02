# Ansible

## Installation
* [Installing Ansible](docs/installation.md)

## Usefull ad hoc commands

```
ansible -m ping host1
ansible -b -m ping host1
ansible -b -m reboot host1
```

## Running Playbooks

List hosts, don't run the actual playbook.
```
ansible-playbook update-all-packages.yml --list-hosts
```

Limit a playbook to the specific host or group.
```
ansible-playbook update-all-packages.yml --limit 'group1'
```


## References
* [Ansible Documentation / Introduction to ad hoc commands](https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html)
* [Ansible Documentation / Patterns: targeting hosts and groups](https://docs.ansible.com/ansible/latest/inventory_guide/intro_patterns.html)
* [Inventory file](inventory/hosts)