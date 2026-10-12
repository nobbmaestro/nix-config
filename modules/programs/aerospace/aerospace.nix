{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.aerospace = inputs.wrapper-modules.lib.evalPackage [
        self.modules.aerospace.main
        { inherit pkgs; }
      ];
    };

  flake.modules.aerospace.main =
    {
      wlib,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ wlib.modules.default ];

      package = lib.mkDefault pkgs.aerospace;
    };

  flake.modules.hjem.aerospace =
    { pkgs, ... }:
    let
      ws = builtins.elemAt [
        "0:home"
        "1:term"
        "2:web"
        "3:dev-web"
        "4:chat"
        "5:mail"
        "6:notes"
        "7:other-1"
        "8:other-2"
        "9:other-3"
      ];
      settings = {
        start-at-login = false;

        after-startup-command = [ "workspace ${ws 0}" ];

        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;

        accordion-padding = 30;
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";

        key-mapping.preset = "qwerty";

        on-focus-changed = [ "move-mouse window-lazy-center" ];
        on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

        gaps = {
          inner.horizontal = 8;
          inner.vertical = 8;
          outer.left = 8;
          outer.bottom = 8;
          outer.top = 8;
          outer.right = 8;
        };

        mode.main.binding = {
          # See: https://nikitabobko.github.io/AeroSpace/commands#layout
          alt-f = "fullscreen";
          alt-period = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";

          # See: https://nikitabobko.github.io/AeroSpace/commands#resize
          alt-minus = "resize smart -50";
          alt-equal = "resize smart +50";
          alt-backspace = "balance-sizes";

          # See: https://nikitabobko.github.io/AeroSpace/commands#focus
          alt-ctrl-h = "focus left";
          alt-ctrl-j = "focus down";
          alt-ctrl-k = "focus up";
          alt-ctrl-l = "focus right";

          # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
          ctrl-0 = "workspace ${ws 0}";
          ctrl-1 = "workspace ${ws 1}";
          ctrl-2 = "workspace ${ws 2}";
          ctrl-3 = "workspace ${ws 3}";
          ctrl-4 = "workspace ${ws 4}";
          ctrl-5 = "workspace ${ws 5}";
          ctrl-6 = "workspace ${ws 6}";
          ctrl-7 = "workspace ${ws 7}";
          ctrl-8 = "workspace ${ws 8}";
          ctrl-9 = "workspace ${ws 9}";

          # See: https://nikitabobko.github.io/AeroSpace/commands#mode
          ctrl-m = "mode modify";
        };

        mode.modify.binding = {
          esc = [
            "reload-config"
            "mode main"
          ];
          backspace = [
            "close-all-windows-but-current"
            "mode main"
          ];

          l = [
            "workspace-back-and-forth"
            "mode main"
          ];
          r = [
            "flatten-workspace-tree"
            "mode main"
          ];
          f = [
            "layout floating tiling"
            "mode main"
          ];

          # See: https://nikitabobko.github.io/AeroSpace/commands#move
          ctrl-h = "move left";
          ctrl-j = "move down";
          ctrl-k = "move up";
          ctrl-l = "move right";

          # See: https://nikitabobko.github.io/AeroSpace/commands#join
          alt-ctrl-h = [
            "join-with left"
            "mode main"
          ];
          alt-ctrl-k = [
            "join-with up"
            "mode main"
          ];
          alt-ctrl-j = [
            "join-with down"
            "mode main"
          ];
          alt-ctrl-l = [
            "join-with right"
            "mode main"
          ];

          # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
          "0" = [
            "move-node-to-workspace ${ws 0}"
            "workspace ${ws 0}"
            "mode main"
          ];
          "1" = [
            "move-node-to-workspace ${ws 1}"
            "workspace ${ws 1}"
            "mode main"
          ];
          "2" = [
            "move-node-to-workspace ${ws 2}"
            "workspace ${ws 2}"
            "mode main"
          ];
          "3" = [
            "move-node-to-workspace ${ws 3}"
            "workspace ${ws 3}"
            "mode main"
          ];
          "4" = [
            "move-node-to-workspace ${ws 4}"
            "workspace ${ws 4}"
            "mode main"
          ];
          "5" = [
            "move-node-to-workspace ${ws 5}"
            "workspace ${ws 5}"
            "mode main"
          ];
          "6" = [
            "move-node-to-workspace ${ws 6}"
            "workspace ${ws 6}"
            "mode main"
          ];
          "7" = [
            "move-node-to-workspace ${ws 7}"
            "workspace ${ws 7}"
            "mode main"
          ];
          "8" = [
            "move-node-to-workspace ${ws 8}"
            "workspace ${ws 8}"
            "mode main"
          ];
          "9" = [
            "move-node-to-workspace ${ws 9}"
            "workspace ${ws 9}"
            "mode main"
          ];

          # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
          tab = [
            "move-workspace-to-monitor --wrap-around next"
            "mode main"
          ];
        };

        on-window-detected = [
          {
            "if".app-id = "net.kovidgoyal.kitty";
            run = "move-node-to-workspace ${ws 1}";
          }
          {
            "if".app-id = "com.apple.Safari";
            check-further-callbacks = true;
            run = "move-node-to-workspace ${ws 2}";
          }
          {
            "if".app-id = "com.apple.Safari";
            "if".window-title-regex-substring = "Development";
            check-further-callbacks = true;
            run = "move-node-to-workspace ${ws 3}";
          }
          {
            "if".app-id = "org.mozilla.Firefox";
            run = "move-node-to-workspace ${ws 3}";
          }
          {
            "if".app-id = "com.microsoft.teams";
            run = "move-node-to-workspace ${ws 4}";
          }
          {
            "if".app-id = "com.microsoft.teams2";
            run = "move-node-to-workspace ${ws 4}";
          }
          {
            "if".app-id = "net.whatsapp.WhatsApp";
            run = "move-node-to-workspace ${ws 4}";
          }
          {
            "if".app-id = "com.apple.mail";
            run = "move-node-to-workspace ${ws 5}";
          }
          {
            "if".app-id = "com.microsoft.Outlook";
            run = "move-node-to-workspace ${ws 5}";
          }
          {
            "if".app-id = "md.obsidian";
            run = "move-node-to-workspace ${ws 6}";
          }
          {
            "if".app-id = "com.apple.iBooksX";
            run = "move-node-to-workspace ${ws 7}";
          }
          {
            "if".app-id = "com.apple.Preview";
            run = "move-node-to-workspace ${ws 7}";
          }
        ];
      };
    in
    {
      xdg.config.files."aerospace/aerospace.toml".source =
        (pkgs.formats.toml { }).generate "aerospace.toml"
          settings;
    };
}
