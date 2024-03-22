# My pre-commit config

This is my personal config for pre-commit that I use on a daily basis.

From time to time, use `pre-commit autoupdate`.

Building: `docker build -t maxhomann/pre-commit .`

Usage (Win): `docker run --rm -ti -v //$(pwd):/opt/repo maxhomann/pre-commit`

Shortcut (Win, git Bash): `echo "alias prec='docker run --rm -ti -v //$(pwd):/opt/repo maxhomann/pre-commit'" >> ~/.profile`


## TODO

- repair gitleaks. Cant find any commits
- use ruff for python linting
- use checkov for IaC SAST
- Reduce image size
