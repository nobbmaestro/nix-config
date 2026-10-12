{
  inputs,
  ...
}:
{
  flake.modules.darwin.system-tools = {
    imports = with inputs.self.modules.darwin; [
      system-shell
    ];
  };

  flake.modules.hjem.system-tools =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.hjem; [
        system-shell

        tmux
      ];

      packages =
        (with inputs.self.packages.${pkgs.system}; [
          claude-code
          lazydocker
          lazygit
          neovim
          tmux
          yazi
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
          colima
          git-fame
          gitlab-ci-local
          picocom
          python3
          speedtest-cli

          # shell
          zoxide
        ]);
    };

  flake.modules.homeManager.system-tools = {
    imports = with inputs.self.modules.homeManager; [
      system-shell

      direnv
      fzf
      lazydocker
      lazygit
    ];
  };
}
