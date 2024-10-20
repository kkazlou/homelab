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

## References

* [Docker Documentation / Docker Contexts](https://docs.docker.com/cloud/docker-contexts/)
* [Ansible playbook to install Docker Engine](../ansible/install-docker-engine.yml)