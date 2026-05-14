{
  description = "Fuchsia Cursor build with custom colors";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = self.packages.${system}.fuchsia-nix;
          
          fuchsia-nix = pkgs.callPackage ./nix/package.nix {};
        });

      homeModules.default = import ./nix/hm-module.nix;
      nixosModules.default = import ./nix/nixos-module.nix;
    };
}
