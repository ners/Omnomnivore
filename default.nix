{ mkDerivation, aeson, base, Cabal, greskell, greskell-core
, greskell-websocket, lib, mtl, text, text-format
}:
mkDerivation {
  pname = "Omnomnivore";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base greskell greskell-core greskell-websocket mtl text
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base Cabal text text-format ];
  homepage = "https://github.com/ners/Omnomnivore";
  description = "Recipes in graph databases. Slurp.";
  license = lib.licenses.asl20;
}
