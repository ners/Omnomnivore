{ mkDerivation, base, greskell, greskell-core, greskell-websocket
, lib, mtl, text
}:
mkDerivation {
  pname = "Omnomnivore";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base greskell greskell-core greskell-websocket mtl text
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base ];
  homepage = "https://github.com/ners/Omnomnivore";
  description = "Recipes in graph databases. Slurp.";
  license = lib.licenses.asl20;
}
