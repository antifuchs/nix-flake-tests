{
  description = "a failing test";

  inputs = {
    nix-flake-tests.url = "path:../../"; # In the real world, use "github:antifuchs/nix-flake-tests"
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, nix-flake-tests }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      checks = {
        basic =
          nix-flake-tests.lib.check system (pkgs.lib.runTests {
            testNumbers = { expected = 2; expr = 1; };
            testString = { expected = "hello"; expr = "hi"; };
            testList = { expected = [ "hello" ]; expr = [ "hi" ]; };
            testAttrs = { expected = { hi = "you"; }; expr = { hi = "there"; }; };
          });
      };
    });
}
