{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    aspire-cli = {
      url = "github:kennethhoff/aspire-cli-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    aspire-cli,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        aspire = aspire-cli.packages.${system}.aspire-cli;
        dotnet = pkgs.dotnetCorePackages.combinePackages [
          pkgs.dotnetCorePackages.sdk_10_0
        ];
      in {
        devShells.default = pkgs.mkShell {
          formatter = pkgs.nixfmt;

          packages = [
            aspire
            dotnet
          ];
        };
      };
    };
}
