{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.lazyhis = inputs.wrapper-modules.lib.evalPackage [
        self.modules.lazyhis.main
        { inherit pkgs; }
      ];
    };

  flake.modules.lazyhis.main =
    {
      wlib,
      pkgs,
      lib,
      ...
    }:
    let
      yaml = pkgs.formats.yaml { };

      settings = {
        db.excludeCommands = [
          "^ls$"
          "^la$"
          "^cd$"
          "^cd ..$"
          "^c$"
          "^clear$"
          "^exit$"
          "^vim$"
          "^nvim$"
        ];

        gui = {
          columnLayout = [
            "EXIT_CODE"
            "EXECUTED_AT"
            "COMMAND"
          ];

          cyclicFilterModes = [
            "SESSION_FILTER"
            "WORKDIR_FILTER"
            "SUCCESS_FILTER"
            "NO_FILTER"
          ];

          persistentFilterModes = [ "UNIQUE_FILTER" ];

          theme = {
            borderColor = "#3a3e4b";
            versionFgColor = "#00e8c6";
            helpFgColor = "#606064";
            helpAccentColor = "#00e8c6";
            inputFgColor = "#d5ced9";
            filterFgColor = "#606064";
            tableCursorFgColor = "#00e8c6";
            tableCursorBgColor = "#2f323c";
            tableLabelsFgColor = "#d5ced9";
          };
        };

        os.fetchCurrentSessionCmd = "tmux display-message -p '#S'";

        log = {
          logEnabled = false;
          logLevel = "DEBUG";
          logFile = "~/Library/Logs/lazyhis.log";
        };
      };
    in
    {
      imports = [ wlib.modules.default ];

      package = lib.mkDefault inputs.lazyhis.packages.${pkgs.system}.default;

      wrapperImplementation = "binary";

      env = {
        LAZYHIS_CONFIG = yaml.generate "lazyhis.yml" settings;
        LAZYHIS_DB = "~/.lazyhis.db";
      };
    };

  flake.modules.homeManager.lazyhis = {
    programs.zsh = {
      history = {
        save = 0;
        size = 0;
        ignoreAllDups = true;
        ignoreSpace = true;
      };

      initContent = ''
        if type "lazyhis" >/dev/null 2>&1; then
          if type "zvm_version" >/dev/null 2>&1; then
            zvm_after_init_commands+=('eval "$(lazyhis init zsh)"')
          else
            eval "$(lazyhis init zsh)"
          fi
        fi
      '';
    };
  };
}
