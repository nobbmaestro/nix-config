{
  inputs,
  ...
}:
{
  # Setup of tools for dendritic pattern

  # Simpify Nix Flakes with the module system
  # https://github.com/hercules-ci/flake-parts

  # Import all nix files in a directory tree.
  # https://github.com/vic/import-tree

  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  systems = [
    "aarch64-darwin"
    "x86_64-linux"
    "aarch64-linux"
  ];

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
}
