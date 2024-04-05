# My pre-commit config

This is my personal config for pre-commit that I use on a daily basis.

From time to time, use `pre-commit autoupdate`.

Building: 
```shell
docker build -t maxhomann/pre-commit:full .
docker build -t maxhomann/pre-commit:linting -f linting-only/Dockerfile linting-only
```

Usage (Win): `docker run --rm -ti -v //$(pwd):/opt/repo maxhomann/pre-commit`

Shortcuts (Win, git Bash): 

```shell
echo 'alias pc-l="docker run --rm -ti -v //$(pwd):/opt/repo maxhomann/pre-commit:linting"' >> ~/.profile
echo 'alias pc="docker run --rm -ti -v //$(pwd):/opt/repo maxhomann/pre-commit:full"' >> ~/.profile
```

## TODO

- repair gitleaks. Cant find any commits
- use ruff for python linting
- use checkov for IaC SAST
- Reduce image size
