{
  lib,
  pkgs,
  crane,
  src,
}:
let
  craneLib = crane.mkLib pkgs;

  # Common arguments can be set here to avoid repeating them later
  # Note: changes here will rebuild all dependency crates
  commonArgs = {
    src = lib.cleanSourceWith {
      src = craneLib.path src;
    };

    strictDeps = true;
  };

  givc = craneLib.buildPackage (
    commonArgs
    // {
      outputs = [
        "out"
      ];
      cargoArtifacts = craneLib.buildDepsOnly commonArgs;
    }
  );
in
givc
