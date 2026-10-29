{
  # A development shell containing all packages exposed by this flake,
  # for use outside NixOS and nix-darwin.
  #
  #   nix develop github:nobbmaestro/nix-config
  #

  perSystem =
    { pkgs, self', ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        name = "nix-config";

        packages = builtins.attrValues self'.packages;
      };
    };
}
