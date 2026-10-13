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

        direnv
        tmux
        nvim-lazygit-navigation
      ];

      packages =
        (with inputs.self.packages.${pkgs.system}; [
          claude-code
          direnv
          eza
          fzf
          lazydocker
          lazygit
          neovim
          tmux
          yazi
          zoxide
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
        ]);
    };
}
