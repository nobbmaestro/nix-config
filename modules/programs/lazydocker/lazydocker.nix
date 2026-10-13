{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.lazydocker = inputs.wrapper-modules.lib.evalPackage [
        self.modules.lazydocker.main
        { inherit pkgs; }
      ];
    };

  flake.modules.lazydocker.main =
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
              "#00e8c6"
              "bold"
            ];
            inactiveBorderColor = [ "#464959" ];
            searchingActiveBorderColor = [
              "#00e8c6"
              "bold"
            ];
            optionsTextColor = [ "#7cb7ff" ];
            selectedLineBgColor = [ "#3a3e4b" ];
            selectedRangeBgColor = [ "#3a3e4b" ];
            cherryPickedCommitBgColor = [ "#00e8c6" ];
            cherryPickedCommitFgColor = [ "#7cb7ff" ];
            unstagedChangesColor = [ "#ee5d43" ];
            defaultFgColor = [ "#d5ced9" ];
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

  flake.modules.zsh.lazydocker = {
    zshAliases = {
      lzd = "lazydocker";
    };
  };
}
