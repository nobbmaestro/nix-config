{
  self,
  ...
}:
let
  theme = self.theme;
  inherit (theme) palette;
in
{
  flake.wrappers.lazydocker =
    {
      wlib,
      pkgs,
      lib,
      ...
    }:
    let
      yaml = pkgs.formats.yaml { };

      settings = {
        commandTemplates.dockerCompose = "docker compose";

        gui = {
          border = "rounded";
          nerdFontsVersion = "3";
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

        os.editPreset = "nvim";
      };

      configDir = pkgs.linkFarm "lazydocker-config" {
        "config.yml" = yaml.generate "config.yml" settings;
      };
    in
    {
      imports = [ wlib.modules.default ];

      package = lib.mkDefault pkgs.lazydocker;
      env.CONFIG_DIR = "${configDir}";
    };

  flake.wrappers.zsh = {
    zshAliases = {
      lzd = "lazydocker";
    };
  };
}
