let
  inputs = import ../../npins;
  pkgs = import inputs.nixpkgs { };
  projectName  = "PEPR-cyber-poster";
in
pkgs.stdenv.mkDerivation {
  name = projectName;
  src = ./.;

  fontsPath = builtins.path {
    path = ../../fonts/Marianne;
    name = "custom-fonts";
  };

  nativeBuildInputs = [
    pkgs.typst
  ];

  buildPhase = ''
    ln -s $fontsPath fonts
    typst compile --font-path=fonts main.typ ${projectName}.pdf;
  '';

  installPhase = ''
    mkdir -p $out
    cp -r ${projectName}.pdf $out/
  '';
}
