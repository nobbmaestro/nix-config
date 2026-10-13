{
  self,
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
      inherit (self.theme) palette;

      themeConfig = pkgs.writeText "bubbles.conf" ''
        # Inspired by: https://www.reddit.com/r/neovim/comments/10fmg2e/neovim_and_his_beloved_buddy_tmux/#lightbox

        # symbols
        nerdfont_left=""
        nerdfont_right=""

        # formats
        pane_format="#I #W"
        prefix_format="#[fg=${palette.cyan}]$nerdfont_left#[fg=${palette.mono_0}]#[bg=${palette.cyan}]"󰘶"#[bg=default]#[fg=${palette.cyan}]$nerdfont_right"
        zoomed_format="#[fg=${palette.cyan}]$nerdfont_left#[fg=${palette.mono_0}]#[bg=${palette.cyan}]"Z"#[bg=default]#[fg=${palette.cyan}]$nerdfont_right"

        # components
        prefix_component="#{?client_prefix,$prefix_format,}"
        zoomed_component="#{?window_zoomed_flag,$zoomed_format,}"
        session_component="#[fg=${palette.mono_5}]$nerdfont_left#[fg=${palette.mono_0}]#[bg=${palette.mono_5}]#S#[bg=default]#[fg=${palette.mono_5}]$nerdfont_right"

        # options
        set-option -g status-style bg=default
        set-option -g message-style bg=default,fg=${palette.blue}
        set-option -g pane-border-style fg=${palette.mono_1}
        set-option -g pane-active-border-style fg=${palette.mono_5}
        set-option -g mode-style bg=${palette.mono_3}

        # popup window
        set -g popup-border-lines rounded
        set -g popup-border-style fg=${palette.mono_3}

        # status bar settings
        set -g status-left "$session_component "
        set -g status-right "$prefix_component $zoomed_component"
        set -g window-status-format "#[fg=${palette.mono_1}]$nerdfont_left#[fg=${palette.mono_5}]#[bg=${palette.mono_1}]$pane_format#[bg=default]#[fg=${palette.mono_1}]$nerdfont_right"
        set -g window-status-current-format "#[fg=${palette.mono_3}]$nerdfont_left#[fg=${palette.mono_5},bold]#[bg=${palette.mono_3}]$pane_format#[bg=default]#[fg=${palette.mono_3}]$nerdfont_right"
        set -g status-justify absolute-centre
      '';

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
        set-option -g default-command "${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace -l ${
          self.packages.${pkgs.system}.zsh
        }/bin/zsh"

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
        source-file ${themeConfig}
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
