{
  description = "A flake that allows hooking nixpkgs' lib.runTests up to `nix flake check`.";

  inputs = { };

  outputs = { self }: {
    lib = import ./.;
  };
}
