{
  flake.modules.zsh.eza = {
    zshAliases = {
      la = "ls -al";
      ll = "ls -l";
      ls = "eza --icons --classify --group-directories-first";
      lt = "eza --tree --group-directories-first";
    };

    env.EZA_COLORS = "di=37;1:fi=37:ex=31:ln=35;1";
  };
}
