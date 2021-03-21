let
  check = system: results:
    let
      formatValue = val:
        if (builtins.isList val || builtins.isAttrs val) then builtins.toJSON val
        else builtins.toString val;
      resultToString = { name, expected, result }: ''
        ${name} failed: expected ${formatValue expected}, but got ${
          formatValue result
        }
      '';
    in
    if results != [ ] then
      builtins.throw (builtins.concatStringsSep "\n" (map resultToString results))
    else
      builtins.derivation {
        name = "nix-flake-tests-success";
        builder = "echo > $out";
        inherit system;
      };
  lib = {
    inherit
      check
      ;
  };
in
lib
