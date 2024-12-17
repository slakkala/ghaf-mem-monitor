# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  description = "Virtual machine dynamic memory manager";

  # Inputs
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-root = {
      url = "github:srid/flake-root";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane = {
      url = "github:ipetkov/crane";
    };
    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      crane,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      imports = [
        ./nixos/checks/treefmt.nix
        ./devshell.nix
      ];

      perSystem =
        { pkgs, ... }:
        {
          # Packages
          packages.mem-manager = pkgs.callPackage ./nixos/packages/ghaf-mem-manager.nix {
            inherit crane;
            src = ./.;
          };
        };
      flake = {
        # Overlays
        overlays.default = _final: prev: {
          inherit (self.packages.${prev.stdenv.hostPlatform.system}) mem-manager;
        };
      };
    };
}
