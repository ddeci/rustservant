{
  description = "RustServant - Rust+ API integration tool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Rust
            rustc
            cargo
            clippy
            rustfmt
            rust-analyzer

            # Node.js
            nodejs_22

            # Build deps
            pkg-config
            openssl
            protobuf
          ];

          shellHook = ''
            echo "rustservant dev shell"
          '';

          CARGO_BUILD_INCREMENTAL = "true";
          RUST_BACKTRACE = "1";
        };

        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "rustservant";
          version = "0.1.0";
          src = ./.;

          cargoLock.lockFile = ./Cargo.lock;

          nativeBuildInputs = [ pkgs.pkg-config pkgs.protobuf ];
          buildInputs = [ pkgs.openssl ];

          doCheck = false;
        };
      }
    );
}
