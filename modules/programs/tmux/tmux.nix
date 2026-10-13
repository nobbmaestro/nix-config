{
  inputs,
  ...
}:
{
  flake.wrappers.tmux =
    {
      wlib,
      pkgs,
      ...
    }:
    let
      tmuxTether = inputs.tmux-tether.packages.${pkgs.system}.default;
    in
    {
      imports = [ wlib.wrapperModules.tmux ];

      prefix = "C-s";
      escapeTime = 500;
      disableConfirmationPrompt = false;

      plugins = with pkgs.tmuxPlugins; [
        { plugin = sensible; }
        { plugin = yank; }
        {
          plugin = resurrect;
          configBefore = ''
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
            set -g @resurrect-save 'S'
          '';
        }
        {
          plugin = continuum;
          configBefore = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '10'
          '';
        }
      ];

      configAfter = ''
        # macOS: reattach so GUI apps spawned from tmux can register with LaunchServices
        set-option -g default-command "${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace -l ${pkgs.zsh}/bin/zsh"

        # Options
        set-option -g history-file ~/.tmux_history

        # QoL
        set-option -g mouse on
        set-option -g detach-on-destroy off

        # True colors
        set -g default-terminal "tmux-256color"
        set -sg terminal-overrides ",*:RGB"

        # Disable 'scroll-to-bottom' behavior on mouse highlight in copy-mode
        set -g @yank_action 'copy-pipe' # or 'copy-pipe-and-cancel' for the default

        # Status length
        set -g status-left-length 50
        set -g status-right-length 100

        # Indexing
        set -g base-index 1
        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows on

        # Prefix
        unbind C-b
        set-option -g prefix C-s
        bind-key C-s send-prefix

        # Popup
        bind-key -n C-f display-popup -T "#[fg=colour6,align=centre] Find Sessions" -w 50% -h 40% -E "${tmuxTether}/bin/tt"

        # Splits
        bind h split-window -v -c "#{pane_current_path}"
        bind v split-window -h -c "#{pane_current_path}"

        # Navigator logic
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

        # Theme
        source-file ${./etc/themes/colors/andromeda.conf}
        source-file ${./etc/themes/bubbles.conf}
      '';
    };

  flake.modules.hjem.tmux =
    { pkgs, ... }:
    let
      topen = pkgs.writeShellApplication {
        name = "topen";
        runtimeInputs = with pkgs; [
          tmux
        ];
        text = builtins.readFile ./bin/topen;
      };
    in
    {
      packages = [ topen ];

      xdg.config.files."tmux-tether".source = ./etc/tmux-tether.yml;
    };
}
