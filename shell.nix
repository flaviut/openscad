{ pkgs ? import <nixpkgs> { }, openscad ? pkgs.callPackage ./package.nix {} }:
let
  extras = [ pkgs.imagemagick pkgs.clang-tools ];
in
pkgs.mkShell {
  nativeBuildInputs = openscad.nativeBuildInputs ++ (openscad.nativeCheckInputs or []);

  buildInputs = openscad.buildInputs ++ extras;

  shellHook = ''
    # if the user already has ccache installed, presumably they intend it to be used:
    if command -v ccache >/dev/null; then
      export CMAKE_C_COMPILER_LAUNCHER=ccache CMAKE_CXX_COMPILER_LAUNCHER=ccache
    fi
  '';

  # avoid segfault when showing a file dialog or color picker
  # this is usually handled by GTK wrappers during package build
  GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
}
