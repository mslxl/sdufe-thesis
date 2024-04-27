{
  description = "山东财经大学 毕业论文 LaTeX 模板";

  inputs.utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        # Used by `nix develop`
        devShells.default = pkgs.mkShell rec {
          buildInputs = with pkgs; [
            plantuml
            mermaid-cli
            just
            tectonic
          ];

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
        };
      }
    );
}
