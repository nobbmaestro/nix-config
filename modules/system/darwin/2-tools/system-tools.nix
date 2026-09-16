{
  inputs,
  ...
}:
{
  flake.modules.darwin.system-tools = {
    imports = with inputs.self.modules.darwin; [
      system-shell

      claude-code
    ];
  };

  flake.modules.homeManager.system-tools =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        system-shell

        claude-code
        direnv
        fzf
        git
        lazydocker
        lazygit
        tmux
        yazi
      ];

      home.packages =
        (with inputs.self.packages.${pkgs.system}; [
          neovim
        ])
        ++ (with pkgs; [
          curl
          gitflow
          htop
          nix-direnv
          ripgrep
          tio
          tldr
          wget

          # dev
          arduino-cli
          bear
          docker
          git-fame
          gitlab-ci-local
          picocom
          python3
          speedtest-cli

          # shell
          starship
          zoxide
        ]);
    };
}
