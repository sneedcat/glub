{
  description = "Modular Nix Packages Overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" ];

      forAllSystems =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.Overlay ];
            };
          }
        );
    in
    {
      Overlay = import ./default.nix;

      packages = forAllSystems (
        { pkgs }:
        {
          helium = pkgs.glub.packages.${pkgs.stdenv.system}.helium;
          opencode = pkgs.glub.packages.${pkgs.stdenv.system}.opencode;
        }
      );

      apps = forAllSystems (
        { pkgs }:
        {
          helium = {
            type = "app";
            program = "${self.packages.${pkgs.system}.default}/bin/helium";
          };
          opencode = {
            type = "app";
            program = "${self.packages.${pkgs.system}.default}/bin/opencode";
          };
        }
      );
    };
}
