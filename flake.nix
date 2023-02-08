{
  description = "A flake that allows hooking nixpkgs' lib.runTests up to `nix flake check`.";

  inputs = { };

  outputs = { self }: rec {
    lib = import ./.;
    overlays.default = final: prev: {
      nix-flake-tests = tests: lib.check {inherit tests; pkgs = final;};
    };
  };
}
