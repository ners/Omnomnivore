{ mkDerivation, base, Cabal, lib, text, text-format }:
mkDerivation {
  pname = "Omnomnivore";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base text ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base Cabal text text-format ];
  homepage = "https://github.com/ners/Omnomnivore";
  description = "Recipes in graph databases. Slurp.";
  license = lib.licenses.asl20;
}
