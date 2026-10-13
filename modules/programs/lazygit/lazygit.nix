{
  self,
  ...
}:
let
  theme = self.theme;
  inherit (theme) palette;
in
{
  flake.wrappers.lazygit =
    {
      wlib,
      pkgs,
      lib,
      config,
      ...
    }:
    let
      yaml = pkgs.formats.yaml { };
    in
    {
      imports = [ wlib.modules.default ];

      options.settings = lib.mkOption {
        type = yaml.type;
        default = { };
      };

      config = {
        package = lib.mkDefault pkgs.lazygit;
        flags."--use-config-file" = yaml.generate "lazygit-config.yml" config.settings;

        settings.gui = {
          border = "rounded";
          nerdFontsVersion = 3;
          timeFormat = "02 Jan 06";
          shortTimeFormat = "15:04";
          theme = {
            activeBorderColor = [
              theme.accent
              "bold"
            ];
            inactiveBorderColor = [ theme.border ];
            searchingActiveBorderColor = [
              theme.accent
              "bold"
            ];
            optionsTextColor = [ palette.blue ];
            selectedLineBgColor = [ theme.selection ];
            selectedRangeBgColor = [ theme.selection ];
            cherryPickedCommitBgColor = [ theme.accent ];
            cherryPickedCommitFgColor = [ palette.blue ];
            unstagedChangesColor = [ palette.red ];
            defaultFgColor = [ theme.fg ];
          };
        };
      };
    };

  flake.wrappers.zsh = {
    zshAliases = {
      lzg = "lazygit";
    };
  };
}
