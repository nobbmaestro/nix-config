{
  inputs,
  ...
}:
{
  flake.modules.darwin.system-shell = {
    imports = with inputs.self.modules.darwin; [
      system-base

      zsh
    ];
  };

  flake.modules.hjem.system-shell =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.hjem; [
        zsh
      ];

      packages = with inputs.self.packages.${pkgs.system}; [
        lazyhis
        starship
        zsh
      ];
    };

  flake.modules.homeManager.system-shell = {
    imports = with inputs.self.modules.homeManager; [
      system-base
    ];
  };
}
