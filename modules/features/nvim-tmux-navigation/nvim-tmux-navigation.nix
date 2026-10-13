{
  ...
}:
{
  flake.wrappers.tmux = {
    configAfter = ''
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      is_fzf="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?fzf$'"
      is_lzg="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?lazygit$'"

      bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
      bind-key -n C-j if-shell "($is_vim || $is_fzf || $is_lzg)" "send-keys C-j" "select-pane -D"
      bind-key -n C-k if-shell "($is_vim || $is_fzf || $is_lzg)" "send-keys C-k" "select-pane -U"
      bind-key -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"

      bind-key -T copy-mode-vi C-h select-pane -L
      bind-key -T copy-mode-vi C-j select-pane -D
      bind-key -T copy-mode-vi C-k select-pane -U
      bind-key -T copy-mode-vi C-l select-pane -R

      bind -r C-h run "tmux select-pane -L"
      bind -r C-j run "tmux select-pane -D"
      bind -r C-k run "tmux select-pane -U"
      bind -r C-l run "tmux select-pane -R"
    '';
  };

  flake.wrappers.neovim =
    { pkgs, ... }:
    {
      specs.nvim-tmux-navigation = with pkgs.vimPlugins; [
        vim-tmux-navigator
      ];
    };
}
