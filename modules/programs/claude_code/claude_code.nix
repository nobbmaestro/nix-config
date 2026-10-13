{
  inputs,
  ...
}:
{
  flake.wrappers.claude-code =
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
