{
  inputs,
  ...
}:
{
  flake.modules.darwin.system-desktop = {
    nixpkgs.config.segger-jlink.acceptLicense = true;

    imports = with inputs.self.modules.darwin; [
      system-tools
    ];

    homebrew.casks = [
      "aldente"
      "alfred"
      "dictionaries"
      "figma"
      "logi-options+"
      "monitorcontrol"
      "obsidian"
      "parallels"
      "saleae-logic"
      "spotify"
      "stremio"
      "the-unarchiver"
      "whatsapp"
      "wireshark-app"
    ];
  };

  flake.modules.hjem.system-desktop =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.hjem; [
        system-tools

        aerospace
        kitty
      ];

      packages =
        (with inputs.self.packages.${pkgs.system}; [
          aerospace
          kitty
        ])
        ++ (with pkgs; [
          segger-jlink
        ]);
    };
}
