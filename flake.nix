{
  description = "Nobbmaestro's Nix Config";

  inputs = {
    # packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # flake infrastructure
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # system
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    # dev tools
    treefmt-nix.url = "github:numtide/treefmt-nix";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";

    # programs
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazyhis = {
      url = "github:nobbmaestro/lazyhis";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tmux-tether = {
      url = "github:nobbmaestro/tmux-tether";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
