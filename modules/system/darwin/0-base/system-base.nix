{
  inputs,
  ...
}:
{
  flake.modules.darwin.system-base =
    {
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.darwin; [
        hjem
        homebrew
      ];

      # Determinate Systems manages the Nix daemon; nix-darwin must not conflict
      nix.enable = false;

      nixpkgs.config.allowUnfree = true;

      system.stateVersion = 6;

      environment.systemPackages = with inputs.nix-darwin.packages.${pkgs.stdenv.hostPlatform.system}; [
        darwin-option
        darwin-rebuild
        darwin-version
        darwin-uninstaller
      ];
    };
}
