{
  inputs,
  ...
}:
{
  perSystem =
    { system, ... }:
    {
      packages.claude-code = inputs.claude-code.packages.${system}.claude-code;
    };

  flake.modules.darwin.claude-code = {
    nixpkgs.overlays = [
      inputs.claude-code.overlays.default
    ];
  };

  flake.modules.homeManager.claude-code =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.claude-code ];
    };
}
