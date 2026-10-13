{
  # Need to copy the desktop apps because otherwise spotlight does not find them.
  # https://gist.github.com/Jabb0/1b7ad92e8ab3065ac999c21edc23311f

  flake.modules.darwin.system-base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      copyNixApps = pkgs.writeShellApplication {
        name = "copy-nix-apps";
        runtimeInputs = with pkgs; [
          coreutils-full
          findutils
        ];
        text = ''
          set -euo pipefail

          NIXAPPS="/etc/profiles/per-user/$(id -un)/Applications"
          [ -d "$NIXAPPS" ] || exit 0

          mkdir -p "$HOME/Applications/Nix Apps"
          rm -rf "$HOME/Applications/Nix Apps"/*

          for app_link in "$NIXAPPS"/*; do
            if [ -d "$app_link" ] || [ -L "$app_link" ]; then
              app_source=$(readlink -f "$app_link")
              appname=$(basename "$app_source")
              target="$HOME/Applications/Nix Apps/$appname"

              mkdir -p "$target/Contents"

              if [ -f "$app_source/Contents/Info.plist" ]; then
                cp -f "$app_source/Contents/Info.plist" "$target/Contents/"
              fi

              if [ -d "$app_source/Contents/Resources" ]; then
                mkdir -p "$target/Contents/Resources"
                find "$app_source/Contents/Resources" -name "*.icns" -exec cp -f {} "$target/Contents/Resources/" \;
              fi

              for dir in "$app_source/Contents"/*; do
                dirname=$(basename "$dir")
                if [ "$dirname" != "Info.plist" ] && [ "$dirname" != "Resources" ]; then
                  ln -sfn "$dir" "$target/Contents/$dirname"
                fi
              done
            fi
          done
        '';
      };
    in
    {
      launchd.user.agents.copy-nix-apps.serviceConfig = {
        Program = lib.getExe copyNixApps;
        Label = "org.nix.copy-nix-apps";
        RunAtLoad = true;
        StandardOutPath = "/var/tmp/copy-nix-apps.out";
        StandardErrorPath = "/var/tmp/copy-nix-apps.err";
      };

      system.activationScripts.applications.text = lib.mkAfter (
        lib.concatMapStringsSep "\n" (u: ''
          if uid="$(${lib.getExe' pkgs.coreutils-full "id"} -u ${u} 2>/dev/null)"; then
            /bin/launchctl kickstart -k "gui/''${uid}/${config.launchd.user.agents.copy-nix-apps.serviceConfig.Label}" 2>/dev/null || true
          fi
        '') (builtins.attrNames config.hjem.users)
      );
    };
}
