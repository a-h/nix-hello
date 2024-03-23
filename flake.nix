{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  };
  outputs = { self, nixpkgs }:
    let
      allSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
      hello = pkgs: pkgs.stdenv.mkDerivation {
        name = "hello";
        src = ./.;
        buildPhase = ''
        '';
        installPhase = ''
          mkdir -p $out/bin
          cp hello.sh $out/bin/hello
          chmod +x $out/bin/hello
        '';
        nativeBuildInputs = [ pkgs.bash ];
      };
    in
    {
      packages = forAllSystems ({ pkgs }: {
        default = hello pkgs;
      });
    };
}
