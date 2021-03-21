let
  check = { pkgs, tests }:
    let
      system = pkgs.stdenv.targetPlatform.system;
      formatValue = val:
        if (builtins.isList val || builtins.isAttrs val) then builtins.toJSON val
        else builtins.toString val;
      resultToString = { name, expected, result }: ''
        ${name} failed: expected ${formatValue expected}, but got ${
          formatValue result
        }
      '';
      results = pkgs.lib.runTests tests;
    in
    if results != [ ] then
      builtins.throw (builtins.concatStringsSep "\n" (map resultToString results))
    ## TODO: The derivation below is preferable but "nix flake check" hangs with it:
    ##       (it's preferable because "examples/many-failures" would then show all errors.)
    # pkgs.runCommand "nix-flake-tests-failure" { } ''
    #   cat <<EOF
    #   ${builtins.concatStringsSep "\n" (map resultToString results)}
    #   EOF
    #   exit 1
    # ''
    else
      pkgs.runCommand "nix-flake-tests-success" { } "echo > $out";
  lib = {
    inherit
      check
      ;
  };
in
lib
