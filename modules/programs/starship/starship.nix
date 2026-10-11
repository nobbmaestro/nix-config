{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.starship = inputs.wrapper-modules.lib.evalPackage [
        self.modules.starship.main
        { inherit pkgs; }
      ];
    };

  flake.modules.starship.main =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.starship ];

      settings = {
        format = "$directory$git_branch$git_status$line_break$character";
        right_format = "$python$lua$nodejs$golang$haskell$rust$ruby$nix_shell$docker_context$jobs$cmd_duration";

        add_newline = true;
        palette = "andromeda";

        character = {
          success_symbol = "[➜](bold white) ";
          vimcmd_symbol = "[󰕷](bold orange) ";
        };

        directory = {
          style = "bold fg:cyan";
          format = "[$path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          truncate_to_repo = false;
        };

        git_branch = {
          style = "fg:gray";
          symbol = " ";
          format = "[on](white) [$symbol$branch ]($style)";
        };

        git_status = {
          style = "fg:red";
          format = "([$all_status$ahead_behind]($style) )";

          staged = "+\${count} ";
          stashed = "*\${count} ";
          modified = "~\${count} ";
          deleted = "!\${count} ";
          behind = "⇣\${count} ";
          ahead = "⇡\${count} ";
          untracked = "?\${count} ";
        };

        fill = {
          symbol = " ";
        };

        python = {
          style = "fg:blue";
          symbol = " ";
          format = "[\${symbol}(\${version} )(\($virtualenv\) )]($style)";
        };

        lua = {
          symbol = " ";
        };

        nodejs = {
          style = "blue";
          symbol = " ";
        };

        golang = {
          style = "blue";
          symbol = " ";
        };

        haskell = {
          style = "blue";
          symbol = " ";
        };

        rust = {
          style = "orange";
          symbol = " ";
        };

        ruby = {
          style = "blue";
          symbol = " ";
        };

        package = {
          symbol = "󰏗 ";
        };

        aws = {
          symbol = " ";
          style = "yellow";
          format = "[$symbol($profile )(\[$duration\] )]($style)";
        };

        nix_shell = {
          symbol = "❄ ";
        };

        docker_context = {
          symbol = " ";
          style = "fg:#06969A";
          format = "[$symbol]($style) $path";
          detect_files = [
            "docker-compose.yml"
            "docker-compose.yaml"
            "Dockerfile"
          ];
          detect_extensions = [ "Dockerfile" ];
        };

        jobs = {
          symbol = " ";
          style = "red";
          number_threshold = 1;
          format = "[$symbol]($style)";
        };

        cmd_duration = {
          min_time = 500;
          style = "fg:gray";
          format = "[$duration]($style)";
        };

        palettes.andromeda = {
          blue = "#7cb7ff";
          red = "#ee5f43";
          green = "#96e072";
          purple = "#c74ded";
          cyan = "#00e8c6";
          orange = "#f39c12";
          yellow = "#ffe66d";
          gray = "#606064";
          white = "#d5ced9";
          pink = "#ff00aa";
          hot_pink = "#f92672";
        };
      };
    };

  flake.modules.homeManager.starship =
    { pkgs, ... }:
    let
      starship = inputs.self.packages.${pkgs.system}.starship;
    in
    {
      programs.zsh.initContent = ''
        eval "$(${starship}/bin/starship init zsh)"
      '';
    };
}
