# packages = with pkgs; [
#   llvmPackages_15.clang-unwrapped
#   cmake
#   cmakeCurses
# ];

{
  description = "Flake for the EEPROM test";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let

      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlay ]; });

    in

    {

      # A Nixpkgs overlay.
      overlay = final: prev: {

        eepromtest = with final; stdenv.mkDerivation rec {
          pname = "eepromtest";
          version = "1";

          nativeBuildInputs = [ pkg-config ];

          src = ./.;


          buildPhase = "${pkgs.clang}/bin/clang++ eepromTest.cpp -o eepromtest libftd2xx/build/libftd2xx.a";
installPhase = "mkdir -p $out/bin; install -t $out/bin eepromtest";
        };

      };

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system:
        {
          inherit (nixpkgsFor.${system}) eepromtest;
        });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      defaultPackage = forAllSystems (system: self.packages.${system}.eepromtest);


    };
}
