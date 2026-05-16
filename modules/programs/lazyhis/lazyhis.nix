{
  self,
  inputs,
  ...
}:
let
  theme = self.theme;
in
{
  flake.wrappers.lazyhis =
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
            borderColor = theme.selection;
            versionFgColor = theme.accent;
            helpFgColor = theme.muted;
            helpAccentColor = theme.accent;
            inputFgColor = theme.fg;
            filterFgColor = theme.muted;
            tableCursorFgColor = theme.accent;
            tableCursorBgColor = theme.bg_alt;
            tableLabelsFgColor = theme.fg;
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

  flake.wrappers.zsh =
    {
      pkgs,
      lib,
      ...
    }:
    let
      lazyhis = self.packages.${pkgs.system}.lazyhis;
    in
    {
      zshrc.content = lib.mkMerge [
        (lib.mkOrder 500 ''
          HISTSIZE=0
          SAVEHIST=0
          setopt HIST_IGNORE_ALL_DUPS
          setopt HIST_IGNORE_SPACE
        '')

        ''
          zvm_after_init_commands+=('eval "$(${lazyhis}/bin/lazyhis init zsh)"')
        ''
      ];
    };
}
