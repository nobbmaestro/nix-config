{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.lazygit = inputs.wrapper-modules.lib.evalPackage [
        self.modules.lazygit.main
        { inherit pkgs; }
      ];
    };

  flake.modules.lazygit.main =
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

  flake.modules.zsh.lazygit = {
    zshAliases = {
      lzg = "lazygit";
    };
  };
}
