{
  self,
  ...
}:
{
  flake.wrappers.kitty =
    { wlib, ... }:
    let
      theme = self.theme;
      inherit (theme) palette;
    in
    {
      imports = [ wlib.wrapperModules.kitty ];

      settings = {
        term = "xterm-256color";

        font_family = "JetBrainsMono Nerd Font Mono";
        bold_font = "JetBrainsMono Nerd Font Mono Bold";
        italic_font = "JetBrainsMono Nerd Font Mono Medium Italic";
        bold_italic_font = "JetBrainsMono Nerd Font Mono Bold Italic";
        font_size = 13.0;
        modify_font = "cell_height 3px";
        disable_ligatures = "never";

        background_opacity = "0.75";
        background_blur = 32;
        dynamic_background_opacity = true;

        confirm_os_window_close = 0;

        window_border_width = "1.00";
        window_padding_width = "5.00";
        window_margin_width = "5.00";
        hide_window_decorations = "titlebar-only";
        macos_show_window_title_in = "window";

        remember_window_size = true;
        initial_window_width = 640;
        initial_window_height = 400;

        mouse_hide_wait = "1.00";
        copy_on_select = true;
        cursor_shape = "block";
        cursor_blink_interval = "0.50";
        shell_integration = "no-cursor";

        enable_audio_bell = false;

        # Basic colors
        foreground = theme.fg;
        background = theme.bg;
        selection_foreground = theme.bg;
        selection_background = theme.fg;

        # Cursor
        cursor = theme.fg;
        cursor_text_color = theme.bg;

        # URL underline on hover
        url_color = palette.blue;

        # Window borders
        active_border_color = theme.accent;
        inactive_border_color = theme.border;
        bell_border_color = palette.yellow;

        # Tab bar
        active_tab_foreground = theme.bg;
        active_tab_background = palette.purple;
        inactive_tab_foreground = theme.fg;
        inactive_tab_background = theme.bg_alt;
        tab_bar_background = theme.bg;

        # Marks (marked text in the terminal)
        mark1_foreground = theme.bg;
        mark1_background = palette.blue;
        mark2_foreground = theme.bg;
        mark2_background = palette.purple;
        mark3_foreground = theme.bg;
        mark3_background = palette.cyan;
      }
      # The 16 terminal colors
      // theme.ansi;
    };

  flake.modules.hjem.kitty =
    { pkgs, ... }:
    {
      xdg.config.files."kitty/kitty.conf".source = "${self.packages.${pkgs.system}.kitty}/kitty.conf";
    };
}
