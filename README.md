# Homelab

## Pre-requirements
Python 3.9 or newer installed

```bash
python3 --version
```

## Installing Ansible
```bash
python3 -m pip install --user ansible
```

## Upgrading Ansible
```bash
python3 -m pip install --upgrade --user ansible
```

## Confirming your installation
```bash
ansible --version
```

## Alternative way to install
by using Python virtual environments
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade -r requirements.txt
```

## References
* [Ansible Documentation / Installing Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
* [Python / Creation of virtual environments](https://docs.python.org/3/library/venv.html)