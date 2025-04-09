# Base Cookiecutter Template for Python Development on Oracle Linux
---

This `cookiecutter` template creates an isolated and complete Python development environment in `docker` using `oracle-linux` as the base image, and shares the same host user and ssh keys.

Example usage:

```sh
cat > "/tmp/config.yml" <<EOF
default_context:
    project_name: Development environment
    project_slut: devenv
    nvim_version: v0.11.0
    oracle_version: 9
    env_vars: 
        array: []
EOF
cookiecutter \
    --no-input \
    --config-file "/tmp/config.yml" \
    "https://github.com/juselara1/python-oracle.template"
```
