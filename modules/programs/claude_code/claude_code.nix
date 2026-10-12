{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.claude-code = inputs.wrapper-modules.lib.evalPackage [
        self.modules.claude-code.main
        { inherit pkgs; }
      ];
    };

  flake.modules.claude-code.main =
    {
      wlib,
      pkgs,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.claude-code ];

      package = inputs.claude-code.packages.${pkgs.system}.claude-code;
    };
}
