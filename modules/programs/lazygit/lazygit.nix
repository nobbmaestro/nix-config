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
      ...
    }:
    let
      yaml = pkgs.formats.yaml { };

      tmux-nvim-open = pkgs.writeShellApplication {
        name = "tmux-nvim-open";
        runtimeInputs = with pkgs; [
          tmux
        ];
        text = builtins.readFile ./bin/tmux-nvim-open;
      };

      settings = {
        gui = {
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

        os = {
          edit = "tmux-nvim-open {{filename}}";
          editAtLine = "tmux-nvim-open {{filename}} {{line}}";
          open = "tmux-nvim-open {{filename}}";
        };
      };
    in
    {
      imports = [ wlib.modules.default ];

      package = lib.mkDefault pkgs.lazygit;
      runtimePkgs = [ tmux-nvim-open ];
      flags."--use-config-file" = yaml.generate "lazygit-config.yml" settings;
    };

  flake.wrappers.zsh = {
    zshAliases = {
      lzg = "lazygit";
    };
  };
}
