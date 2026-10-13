{
  flake.modules.zsh.fzf =
    { pkgs, ... }:
    {
      zshrc.content = ''
        if [[ $options[zle] = on ]]; then
          source <(${pkgs.fzf}/bin/fzf --zsh)
        fi
      '';
    };
}
