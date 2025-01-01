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

```bash { name=setup-00-devbox-show-installed }
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
