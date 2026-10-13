{
  inputs,
  ...
}:
{
  flake.modules.darwin.hjem = {
    imports = [
      inputs.hjem.darwinModules.default
    ];

    hjem.clobberByDefault = true;
  };
}
