final: prev: {
  glub = {
    packages.${prev.stdenv.system} = {
      helium = prev.callPackage ./pkgs/helium.nix { };
      opencode = prev.callPackage ./pkgs/opencode.nix { };
    };
  };
}
