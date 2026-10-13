{
  lib,
  ...
}:
let
  # Upstream: https://github.com/nobbmaestro/dotfiles/blob/base/kitty/andromeda-kitty/andromeda.conf
  palette = {
    mono_0 = "#23262e";
    mono_1 = "#2f323c";
    mono_2 = "#3a3e4b";
    mono_3 = "#464959";
    mono_4 = "#a0a1a7";
    mono_5 = "#d5ced9";

    gray = "#606064";

    red = "#ee5d43";
    orange = "#f39c12";
    yellow = "#ffe66d";
    green = "#96e072";
    cyan = "#00e8c6";
    blue = "#7cb7ff";
    purple = "#c74ded";
    pink = "#ff00aa";
    hot_pink = "#f92672";
  };

  semantic = {
    bg = palette.mono_0;
    bg_alt = palette.mono_1;
    selection = palette.mono_2;
    border = palette.mono_3;
    fg = palette.mono_5;
    muted = palette.gray;
    accent = palette.cyan;
  };

  ansi = {
    color0 = palette.mono_2;
    color8 = palette.mono_3;
    color1 = palette.red;
    color9 = palette.red;
    color2 = palette.green;
    color10 = palette.green;
    color3 = palette.yellow;
    color11 = palette.yellow;
    color4 = palette.blue;
    color12 = palette.blue;
    color5 = palette.pink;
    color13 = palette.pink;
    color6 = palette.cyan;
    color14 = palette.cyan;
    color7 = palette.mono_5;
    color15 = palette.mono_5;
  };

  theme = semantic // {
    inherit palette ansi;
  };
in
{
  options.flake.theme = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.theme = theme;
}
