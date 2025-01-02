# nix-workspace

[![actionlint](https://github.com/vpayno/nix-workspace/actions/workflows/gh-actions.yaml/badge.svg?branch=main)](https://github.com/vpayno/nix-workspace/actions/workflows/gh-actions.yaml)
[![git](https://github.com/vpayno/nix-workspace/actions/workflows/git.yaml/badge.svg?branch=main)](https://github.com/vpayno/nix-workspace/actions/workflows/git.yaml)
[![json](https://github.com/vpayno/nix-workspace/actions/workflows/json.yaml/badge.svg?branch=main)](https://github.com/vpayno/nix-workspace/actions/workflows/json.yaml)
[![markdown](https://github.com/vpayno/nix-workspace/actions/workflows/markdown.yaml/badge.svg?branch=main)](https://github.com/vpayno/nix-workspace/actions/workflows/markdown.yaml)
[![shell](https://github.com/vpayno/nix-workspace/actions/workflows/shell.yaml/badge.svg?branch=main)](https://github.com/vpayno/nix-workspace/actions/workflows/shell.yaml)
[![spellcheck](https://github.com/vpayno/nix-workspace/actions/workflows/spellcheck.yaml/badge.svg?branch=main)](https://github.com/vpayno/nix-workspace/actions/workflows/spellcheck.yaml)
[![woke](https://github.com/vpayno/nix-workspace/actions/workflows/woke.yaml/badge.svg?branch=main)](https://github.com/vpayno/nix-workspace/actions/workflows/woke.yaml)
[![yaml](https://github.com/vpayno/nix-workspace/actions/workflows/yaml.yaml/badge.svg?branch=main)](https://github.com/vpayno/nix-workspace/actions/workflows/yaml.yaml)

Personal Nix workspace for working on Nix flakes and Nix related things.

## Devbox Shell

Using [devbox](https://github.com/jetify-com/devbox) instead of `dev-containers` this year.

Benefits over dev containers?

- Tooling is less complicated.
- It's also easier/faster to make changes and "redeploy".
- Easy way to start learning Nix!
- Sets up a Python virtualenv in the root of the project that you can use to install packages with pip when they aren't available in Nix or for local/private dependencies you haven't added a flake.nix file to.

### Devbox Install

[Install and setup instructions can be found here.](https://github.com/jetify-com/devbox?tab=readme-ov-file#installing-devbox)

```bash { name=setup-00-devbox-show-installed excludeFromRunAll=true }
devbox update
devbox list
```

### Devbox Help

- use `devbox search name` to search for packages
- use `devbox info name` to show the info for a package
- use `devbox add name` to add a package to the shell
- use `devbox update` to update the lock file and environemnt
- use `devbox shell` to start the `nix-shell`
- use `devbox run command` to run a command inside the `nix-shell`

## RunMe Playbook

This and other readme files in this repo are RunMe Playbooks.

Use this playbook step/task to update the [RunMe](https://runme.dev) CLI.

You don't need to install `runme` locally, it's already in the `devbox` shell.

Either run `runme` using `devbox run`:

```bash
devbox run runme
```

or by starting an interactive `devbox shell`:

```bash
devbox shell
runme
```

In playbooks, use the script `./scripts/in-nix-shell` to enforce that the `runme` plays are running in a `nix-shell` when required.

```bash { name=example-play excludeFromRunAll=true }
./scripts/in-nix-shell || exit 1
which runme
```

## Docker & Nix

Experimenting with using `docker` and `nix-build` to build containers.

### Dockerfile

Using this method to manage `Debian` based containers with `nix` instead of `apt`.

To build an Debian+Nix container locally run:

```bash { name=docker-debian-build excludeFromRunAll=true }
docker build --file ./Dockerfile.Debian_with_Nix --tag debian-with-nix .
printf "\n"

docker image ls debian-with-nix
printf "\n"

echo Running: docker run --rm --interactive --tty debian-with-nix which nix
docker run --rm --interactive --tty debian-with-nix which nix
printf "\n"
```

To build an Ubuntu+Nix container locally run:

```bash { name=docker-ubuntu-build excludeFromRunAll=true }
docker build --file ./Dockerfile.Ubuntu_with_Nix --tag ubuntu-with-nix .
printf "\n"

docker image ls ubuntu-with-nix
printf "\n"

echo Running: docker run --rm --interactive --tty ubuntu-with-nix which nix
docker run --rm --interactive --tty ubuntu-with-nix which nix
printf "\n"
```

### nix-build

Using this method to manage `nixos` containers.

To build an example `nixos` container:

```bash { name=nix-build-docker-default excludeFromRunAll=true }
./scripts/in-nix-shell || exit 1

if docker images --format '{{.Repository}}:{{.Tag}}' nixos-base | grep -q ^nixos-base; then
	echo "Deleting previous nixos-base image(s)"
	docker rmi $(docker images --format '{{.Repository}}:{{.Tag}}' nixos-base)
	printf "\n"
fi

nix-build docker-nixos-base.nix
printf "\n"

ls -lh result
printf "\n"

docker load < result
printf "\n"

docker image ls nixos-base
printf "\n"

docker image ls --format=json nixos-base | jq .
printf "\n"

IMAGE_TAG="$(docker image ls --format=json nixos-base | jq -r .Tag)"
IMAGE_ID="$(docker image ls --format=json nixos-base | jq -r .ID)"

docker tag "${IMAGE_ID}" nixos-base:latest
printf "\n"

echo Running: docker run --rm --interactive --tty nixos-base:latest which nix
docker run --rm --interactive --tty nixos-base:latest
printf "\n"
```
