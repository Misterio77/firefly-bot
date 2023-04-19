{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, poetry2nix }: let
      forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  in {
    packages = forEachSystem (system: let
      inherit (poetry2nix.legacyPackages.${system}) mkPoetryApplication;
    in {
      default = mkPoetryApplication {
        projectDir = ./.;
      };
    });

    nixosModules.default = import ./nix/module.nix self;
  };
}
