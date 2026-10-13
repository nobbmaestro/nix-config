<h2 align="center">:snowflake: Nobbmaestro's Nix Config :snowflake:</h2>

<p align="center">
  <a href="https://github.com/nobbmaestro/dotfiles/actions/workflows/build.yml">
    <img alt="macOS Build" src="https://img.shields.io/github/actions/workflow/status/nobbmaestro/dotfiles/build.yml?style=for-the-badge&logo=github&color=A6DA95&logoColor=D9E0EE&labelColor=302D41&label=macOS%20Build"></a>
  <a href="https://github.com/nix-darwin/nix-darwin">
    <img src="https://img.shields.io/badge/nix--darwin-macOS-informational.svg?style=for-the-badge&logo=apple&color=F2CDCD&logoColor=D9E0EE&labelColor=302D41"></a>
  <a href="https://nixos.org/">
    <img src="https://img.shields.io/badge/nixpkgs-unstable-informational.svg?style=for-the-badge&logo=nixos&color=C9CBFF&logoColor=D9E0EE&labelColor=302D41"></a>
</p>

A fully declarative macOS development environment built on Nix flakes and [nix-darwin](https://github.com/nix-darwin/nix-darwin). Organised with the [dendritic pattern](https://dendrix.oeiuwq.com/Dendritic.html) on top of [flake-parts](https://flake.parts/) and [import-tree](https://github.com/vic/import-tree) — drop a `.nix` file in the right place and it's picked up automatically.

## What's included

### System (nix-darwin)

Layered under `modules/system/darwin/`:

- **`0-base`** — core macOS system setup and app fixes
- **`1-shell`** — system-level shell configuration
- **`2-tools`** — system-level CLI tools
- **`3-desktop`** — desktop settings, fonts, keyboard, security, and macOS defaults

### Programs (wrapped)

Per-program modules under `modules/programs/`:

- **Editor / shell**: Neovim, Zsh, Starship, Tmux, Kitty
- **Navigation**: fzf, zoxide, yazi, eza
- **Git workflow**: Git, LazyGit, LazyDocker
- **Window management**: AeroSpace (i3-like tiling WM for macOS)
- **Dev ergonomics**: direnv, [lazyhis](https://github.com/nobbmaestro/lazyhis)

Each program is a single derivation with its configuration baked in, built with
[wrapper-modules](https://github.com/BirdeeHub/nix-wrapper-modules). Declaring
`flake.wrappers.<name>` exposes `packages.<name>` for every system, so a program
module contains configuration only.

### Package management

- Nix (via flakes)
- Homebrew (via [nix-homebrew](https://github.com/zhaofengli/nix-homebrew))

## Repository layout

```
flake.nix                     # minimal entry point — imports ./modules via import-tree
modules/
├── nix/                      # flake-parts setup (lib, wrappers), hjem, homebrew, treefmt
├── system/darwin/            # nix-darwin system layers (0-base … 3-desktop)
├── programs/                 # per-program wrapper modules
├── users/                    # per-user hjem configs (norbertbatiuk, work)
└── hosts/                    # per-host darwin configs
    └── macbook-pro-m1/
        ├── configuration.nix # host-level config
        └── users/            # which users live on this host
```

With the dendritic pattern, every `.nix` file under `modules/` is auto-imported — there is no central import list to maintain. `flake.nix` simply hands the tree to `flake-parts`.

## Getting started

### 1. Install nix

Install nix with the [Determinate Systems installer](https://install.determinate.systems):

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

or, simply run:

```sh
make install
```

### 2. Build the system

The following command will build and apply the full macOS configuration using nix-darwin:

```sh
make switch
```

This defaults to the `macbook-pro-m1` host (see `HNAME` in the `Makefile`) and is equivalent to:

```sh
sudo darwin-rebuild switch --flake .#macbook-pro-m1
```

To target a different host, override `HNAME`:

```sh
make switch HNAME=<hostname>
```

The hostname must match a host defined under `modules/hosts/`.

### 3. Install git hooks

Run once after cloning to install the pre-commit formatter hook:

```sh
nix run .#install-hooks
```

### Other useful targets

```sh
make check     # nix flake check
make update    # nix flake update
make clean     # nix-store --gc
make uninstall # remove nix-darwin
```

## Adding a host or user

- **New host**: create `modules/hosts/<hostname>/configuration.nix` following the pattern in `macbook-pro-m1`, then add `modules/hosts/<hostname>/users/<user>.nix` binding files for each user on that host.
- **New user**: create `modules/users/<user>/` with the user's hjem config, then bind it to one or more hosts via the `users/<user>.nix` files above.

## Resources

- [Dendritic Nix](https://dendrix.oeiuwq.com/Dendritic.html)
- [Dendritic Design with the Flake Parts Framework](https://github.com/Doc-Steve/dendritic-design-with-flake-parts)
- [Ultimate NixOS Desktop: Niri, Noctalia Shell, and the Dendritic Pattern | Full Setup](https://www.youtube.com/watch?v=aNgujRXDTdE)
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world)

## Final Words

This very repository is intended for **_my personal usage_**. Breaking changes, change of utilities, or pattern may occur at any point.

Enjoy!
