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
        basic1 =
          nix-flake-tests.lib.check {
            inherit pkgs;
            tests = {
              testString = { expected = "hello"; expr = "hi"; };
            };
          };
        basic2 =
          nix-flake-tests.lib.check {
            inherit pkgs;
            tests = {
              testNumbers = { expected = 2; expr = 1; };
            };
          };
      };
    });
}
