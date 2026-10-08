{
  description = "DynECC ASIC";

  nixConfig = {
    extra-substituters = [
      "https://nix-cache.fossi-foundation.org"
    ];
    extra-trusted-public-keys = [
      "nix-cache.fossi-foundation.org:3+K59iFwXqKsL7BNu6Guy0v+uTlwsxYQxjspXzqLYQs="
    ];
  };

  inputs.librelane.url = "github:librelane/librelane";

  outputs = { self, librelane, ... }:
    let
      system = "x86_64-linux";
    in {
      devShells.${system}.default =
        librelane.devShells.${system}.default;
    };
}
