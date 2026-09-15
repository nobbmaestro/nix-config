{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    let
      nvim-base = inputs.wrapper-modules.lib.evalPackage [
        self.modules.neovim.main
        { inherit pkgs; }
      ];
    in
    let
      mkWrapper =
        name:
        pkgs.writeShellApplication {
          inherit name;
          runtimeInputs = [ nvim-base ];
          text = ''
            if command -v tmux > /dev/null 2>&1; then
              socket="/tmp/nvim-server-$(tmux display-message -p '#S').sock"
            else
              socket="/tmp/nvim-server-default.sock"
            fi

            if [[ ! -S "$socket" ]]; then
              exec nvim --listen "$socket" "$@"
            else
              exec nvim "$@"
            fi
          '';
        };
    in
    {
      packages.neovim = pkgs.symlinkJoin {
        name = "neovim-${pkgs.neovim-unwrapped.version}";
        paths = [
          (mkWrapper "neovim")
          (mkWrapper "nvim")
          (mkWrapper "vim")
        ];
      };
    };

  flake.modules.neovim.main =
    {
      wlib,
      pkgs,
      ...
    }:
    let
      rsyncer = pkgs.writeShellApplication {
        name = "rsyncer";
        runtimeInputs = with pkgs; [
          rsync
          sshpass
        ];
        text = builtins.readFile ./bin/rsyncer;
      };

      nvim-andromeda = pkgs.vimUtils.buildVimPlugin {
        name = "nvim-andromeda";
        src = pkgs.fetchFromGitHub {
          owner = "nobbmaestro";
          repo = "nvim-andromeda";
          rev = "363a0766713c1381b1b6b3a46d22ac6fd5664569";
          hash = "sha256-O3h9+pAOG8G/nhbzDSWFX73JG8cuTmeIfwgvTYGUidM=";
        };
        doCheck = false;
      };
    in
    {
      imports = [ wlib.wrapperModules.neovim ];
      specs.general = with pkgs.vimPlugins; [
        # colorscheme
        nvim-andromeda
        colorbuddy-nvim

        # editing
        blink-cmp
        conform-nvim
        friendly-snippets
        lazydev-nvim
        luasnip
        undotree
        vim-sleuth

        # git
        gitsigns-nvim

        # navigation
        telescope-nvim
        telescope-fzf-native-nvim
        telescope-ui-select-nvim
        plenary-nvim
        harpoon
        neo-tree-nvim
        vim-tmux-navigator
        nvim-web-devicons
        nui-nvim

        # ui
        indent-blankline-nvim
        lualine-nvim
        rainbow-delimiters-nvim

        # utils
        auto-session
        vim-test
        vimux
        nvim-treesitter.withAllGrammars
      ];

      specs.lazy = {
        lazy = true;
        data = with pkgs.vimPlugins; [
        ];
      };

      runtimePkgs = with pkgs; [
        rsyncer

        # bash
        bash-language-server
        shellcheck
        shfmt

        # clang
        clang-tools

        # golang
        gopls

        # nix
        nil
        nixfmt

        # python
        pyright
        ruff

        # lua
        lua-language-server
        stylua

        # javascript
        prettier

        # telescope
        ripgrep
      ];
      settings.config_directory = ./src;
    };
}
