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

List hosts, don't run the actual playbook.
```
ansible-playbook update-all-packages.yml --list-hosts
```

Limit a playbook to the specific host or group.
```
ansible-playbook update-all-packages.yml --limit group1
```


## References
* [Ansible Documentation / Installation Guide](https://docs.ansible.com/ansible/latest/index.html)
* [Ansible Documentation / Introduction to ad hoc commands](https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html)
* [Ansible Documentation / Patterns: targeting hosts and groups](https://docs.ansible.com/ansible/latest/inventory_guide/intro_patterns.html)
* [Inventory file](inventory/hosts)