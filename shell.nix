{ pkgs ? import <nixpkgs> {}, }:

let
  project = import ./release.nix;
in
pkgs.stdenv.mkDerivation {
  name = "shell";
  buildInputs = project.env.nativeBuildInputs ++ [
    pkgs.boxes
    pkgs.cabal2nix
    pkgs.ghc
    pkgs.gnumake
    pkgs.haskellPackages.haskell-language-server
    pkgs.haskellPackages.cabal-install
    pkgs.lzma
    pkgs.zlib
    pkgs.zlib.dev
  ];
}
