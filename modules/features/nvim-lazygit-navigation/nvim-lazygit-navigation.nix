# Navigation between NeoVim and LazyGit within a Tmux session.
#
# NeoVim exposes a per-session RPC socket configured by `nvim-socket`
# and initialized by the launcher in `programs/nvim`. LazyGit uses
# `tmux-nvim-open` to open files in the running NeoVim instance, while
# `topen` manages Tmux window navigation between the two.
{
  self,
  ...
}:
{
  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {
      packages.nvim-socket = pkgs.writeShellApplication {
        name = "nvim-socket";
        runtimeInputs = with pkgs; [ tmux ];
        text = builtins.readFile ./bin/nvim-socket;
      };

      packages.topen = pkgs.writeShellApplication {
        name = "topen";
        runtimeInputs = with pkgs; [ tmux ];
        text = builtins.readFile ./bin/topen;
      };

      packages.tmux-nvim-open = pkgs.writeShellApplication {
        name = "tmux-nvim-open";
        runtimeInputs = [
          pkgs.tmux
          self'.packages.nvim-socket
          self'.packages.topen
        ];
        text = builtins.readFile ./bin/tmux-nvim-open;
      };
    };

  flake.wrappers.lazygit =
    { pkgs, ... }:
    {
      runtimePkgs = [ self.packages.${pkgs.system}.tmux-nvim-open ];

      settings.os = {
        edit = "tmux-nvim-open {{filename}}";
        editAtLine = "tmux-nvim-open {{filename}} {{line}}";
        open = "tmux-nvim-open {{filename}}";
      };
    };

  flake.wrappers.neovim =
    { pkgs, ... }:
    {
      runtimePkgs = [ self.packages.${pkgs.system}.topen ];

      specs.nvim-lazygit-navigation = {
        data = null;
        type = "lua";
        config = builtins.readFile ./src/lazygit.lua;
      };
    };

  flake.modules.hjem.nvim-lazygit-navigation =
    { pkgs, ... }:
    {
      packages = [ self.packages.${pkgs.system}.topen ];
    };
}
