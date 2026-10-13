{
  inputs,
  ...
}:
{
  # Wrap programs with their configuration into a single derivation.
  # https://github.com/BirdeeHub/nix-wrapper-modules
  #
  # Declaring `flake.wrappers.<name>` exposes `packages.<name>` for every
  # system automatically, so program modules carry configuration only.
  # Definitions merge across files, so several modules may contribute to the
  # same wrapper (see `flake.wrappers.zsh`).

  imports = [
    inputs.wrapper-modules.flakeModules.wrappers
  ];
}
