# nix-flake-tests - Adapt lib.runTests to flake checks

At the moment, [nix flakes](https://nixos.wiki/wiki/Flakes)' `checks` attributes require a derivation to work with `nix flake check`. That's great if you have a shell script or similar program-based check to validate your flake's correctness.

It, unfortunately, super does not work easily if you wish to run tests based on nix, with, e.g. [`lib.runTests`].

This flake fixes that problem for `lib.runTests` specifically, fitting your nix-based tests into one of youru flake's check attributes.

Your flake is expected to acquire a nixpkgs value (via e.g. [`flake-utils`](https://github.com/numtide/flake-utils)) and a set of tests.

## Examples

See [examples/successful-tests/flake.nix] for a worked example that is evaluated in this flake's tests.

A very basic inline example is this:

``` nix
{
  description = "a set of successful tests";

  inputs = {
    nix-flake-tests.url = "github:antifuchs/nix-flake-tests"
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, nix-flake-tests }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      checks = {
        basic =
          nix-flake-tests.lib.check {
            inherit pkgs;
            tests = {
              testWithNumbers = { expected = 1; expr = 1; };
            };
          };
      };
    });
}
```

## Functions

### `check {pkgs, tests}:`

This function is what does the adapting: Pass the `pkgs` for the respective system (using flake-utils) and `tests`. Just like with [`lib.runTests`], `tests` is expected to be an attrset with attribute names starting with "test" for every test that you wish to execute.

[`lib.runTests`]: https://nixos.org/manual/nixpkgs/stable/#function-library-lib.debug.runTests
