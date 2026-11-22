# Docker

## Use Docker Contexts

Create a new Docker context
```
docker context create docker-node01 --docker "host=ssh://docker-node01"
```

Use the new context
```
docker context use docker-node01
```

List Docker contexts
```
docker context ls
```

Switch back to the default context
```
docker context use default
```

## Arcane

[Arcane](https://getarcane.app) manages all Docker nodes from one UI. The manager runs on
the `[arcane_manager]` host (docker-node01, http://docker-node01:3552); the `[arcane_agent]`
hosts run a headless agent that connects out to the manager.
Deployed by [install-arcane.yml](../ansible/install-arcane.yml), secrets in
`ansible/inventory/group_vars/docker/vault.yml` (ansible-vault).

First-time setup (run from `ansible/`):

1. Deploy the manager.
   ```
   ansible-playbook install-arcane.yml --limit arcane_manager
   ```
2. Get the initial admin password (user `arcane`), sign in and change it.
   ```
   ssh docker-node01 'sudo docker cp arcane:/app/data/initial-admin-password - | tar -xO'
   ```
3. In the UI: Agents -> Enrollment Tokens -> Create Enrollment Token. Allow at least as many
   uses as there are agents (one token is shared by all agent hosts).
4. Store the token in the vault as `vault_arcane_agent_token`.
   ```
   ansible-vault edit inventory/group_vars/docker/vault.yml
   ```
5. Deploy the agents.
   ```
   ansible-playbook install-arcane.yml
   ```

Upgrade: bump `arcane_version` in `ansible/inventory/group_vars/docker/vars.yml` and rerun the playbook.

### Logs

The manager container is `arcane` (docker-node01), agents are `arcane-agent` (docker-node02/03).
Log lines look like `Nov 22 14:35:26.072 INF Agent connected environmentId=... transport=grpc`;
levels are `INF`, `WRN` and `ERR`.

On the node:
```
sudo docker logs --tail 50 arcane            # last 50 lines
sudo docker logs -f arcane                   # follow (Ctrl+C to stop)
sudo docker logs --since 10m arcane          # last 10 minutes
sudo docker logs arcane 2>&1 | grep -E 'WRN|ERR'            # warnings and errors only
sudo docker logs arcane 2>&1 | grep -iE 'agent|enroll'      # agent activity
```

From the laptop, with a Docker context (see above):
```
docker --context docker-node01 logs -f arcane
```

From the laptop, with Ansible (run from `ansible/`):
```
ansible docker-node01 -b -m shell -a "docker logs --tail 30 arcane"
ansible arcane_agent -b -m shell -a "docker logs --tail 30 arcane-agent"
```

Container logs can also be viewed in the Arcane UI: open the environment, then Containers, then the container's logs.

## References

* [Docker Documentation / Docker Contexts](https://docs.docker.com/cloud/docker-contexts/)
* [Ansible playbook to install Docker Engine](../ansible/install-docker-engine.yml)
* [Arcane Documentation](https://getarcane.app/docs)
* [Arcane Documentation / Agents](https://getarcane.app/docs/remote/agents)