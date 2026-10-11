{
  self,
  inputs,
  ...
}:
let
  mkGit =
    pkgs: identity:
    inputs.wrapper-modules.lib.evalPackage [
      self.modules.git.main
      identity
      { inherit pkgs; }
    ];
in
{
  flake.lib = { inherit mkGit; };

  perSystem =
    { pkgs, ... }:
    {
      packages.git = mkGit pkgs { };
    };

  flake.modules.git.main =
    {
      wlib,
      pkgs,
      ...
    }:
    let
      ignoreFile = pkgs.writeText "gitignore" ''
        .DS_Store
        .cache/
        .direnv/
        .envrc
        .exrc
        .gitlab-ci-local
        .luarc.json
        .nvmrc
        .python-version
        .rsyncrc
        __pycache__
        compile_commands.json
      '';
    in
    {
      imports = [ wlib.wrapperModules.git ];

      settings = {
        pull.rebase = true;

        core.excludesFile = "${ignoreFile}";

        user.signingKey = "~/.ssh/id_ed25519.pub";
        gpg.format = "ssh";
        "gpg \"ssh\"".program = "${pkgs.openssh}/bin/ssh-keygen";
      };
    };
}
