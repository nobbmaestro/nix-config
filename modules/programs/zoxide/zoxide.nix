{
  flake.modules.zsh.zoxide =
    { pkgs, ... }:
    {
      zshrc.content = ''
        eval "$(${pkgs.zoxide}/bin/zoxide init zsh --cmd cd)"
      '';
    };
}
