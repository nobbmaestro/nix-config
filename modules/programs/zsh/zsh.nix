{
  self,
  ...
}:
{
  flake.wrappers.zsh =
    {
      wlib,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.zsh ];

      hmSessionVariables = null;

      zshAliases = {
        c = "clear";
        rm = "rm -i";
        fman = "compgen -c | fzf --preview='man {}' | xargs man";
      };

      zshenv.content = ''
        export XDG_CACHE_HOME="$HOME/.cache"
        export XDG_CONFIG_HOME="$HOME/.config"
        export XDG_DATA_HOME="$HOME/.local/share"
        export XDG_STATE_HOME="$HOME/.local/state"
      '';

      zshrc.content = lib.mkMerge [
        (lib.mkOrder 500 ''
          typeset -U path cdpath fpath manpath

          ZSH_COMPDUMP="''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
          mkdir -p "''${ZSH_COMPDUMP:h}"
          autoload -U compinit && compinit -u -d "$ZSH_COMPDUMP"
        '')

        (lib.mkOrder 600 ''
          source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
          source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        '')

        ''
          path=("$HOME/.local/bin" $path)
          export PATH
          export EDITOR=nvim
          export VISUAL=nvim
          function benchmark_zsh() {
            shell=''${1-$SHELL}
            for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
          }
          function fstr() {
            grep -Rnw "." -e "$1"
          }
          function ssh() {
            if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
              tmux rename-window "$(echo $*)"
              command ssh "$@"
              tmux set-window-option automatic-rename "on" 1>/dev/null
            else
              command ssh "$@"
            fi
          }
          function truecolor-test() {
            awk -v term_cols="''${width:-$(tput cols || echo 80)}" 'BEGIN{
              s="/\\";
              for (colnum = 0; colnum<term_cols; colnum++) {
                r = 255-(colnum*255/term_cols);
                g = (colnum*510/term_cols);
                b = (colnum*255/term_cols);
                if (g>255) g = 510-g;
                printf "\033[48;2;%d;%d;%dm", r,g,b;
                printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
                printf "%s\033[0m", substr(s,colnum%2+1,1);
              }
              printf "\n";
            }'
          }
        ''
      ];
    };

  flake.modules.hjem.zsh =
    { pkgs, ... }:
    let
      zsh = self.packages.${pkgs.system}.zsh;
    in
    {
      files.".zshenv".text = ''
        export ZDOTDIR="${zsh.ZDOTDIR}"
        source "$ZDOTDIR/.zshenv"
      '';
    };

  flake.modules.darwin.zsh =
    { ... }:
    {
      programs.zsh = {
        enable = true;
        enableGlobalCompInit = false;
      };
    };
}
