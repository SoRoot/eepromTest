{
  description = "Flake for the EEPROM test";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
  {
    flake-utils.lib.eachDefaultSystem (system:
    let pkgs = import nixpkgs {
      inherit system;
    };
    in {
      devShell = pkgs.mkShell rec {
        name = "eempromTest";
        src = self;
        buildPhase = "clang++ -c -E -o eepromTest ./eepromTest/eepromtest.cpp";
        installPhase = "mkdir -p $out/bin; install -t $out/bin eepromTest";
        packages = with pkgs; [
          llvmPackages_15.clang-unwrapped
          cmake
          cmakeCurses
        ];
      };
    });
  };


}
