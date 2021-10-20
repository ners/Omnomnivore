{ mkDerivation, base, lib }:
mkDerivation {
  pname = "Omnomnivore";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base ];
  homepage = "https://github.com/ners/Omnomnivore";
  description = "Recipes in graph databases. Slurp.";
  license = lib.licenses.asl20;
}
