{
  lib,
  stdenvNoCC,
  cbmp,
  clickgen,
  strace,
  name ? "Fuchsia",
  baseColor ? "#E11C79",
  outlineColor ? "#FFFFFF",
}:

stdenvNoCC.mkDerivation {
  pname = "fuchsia-cursor-${name}";
  version = "2.0.1";

  src = ../.;

  nativeBuildInputs = [
    cbmp
    clickgen
  ];

  buildPhase = ''
    set -x
    export HOME=$(pwd)
    #runHook preBuild

    # Render SVGs to bitmaps using CLI arguments
    CI=1 cbmp -d svg -o "bitmaps/${name}" -bc "${baseColor}" -oc "${outlineColor}"

    # Build cursors using clickgen
    # Assuming x.build.toml is correctly set up for the basic build
    ctgen configs/x.build.toml -p x11 -d "bitmaps/${name}" -n "${name}" -c "${name} Cursors" -s 16 18 24 32

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r themes/${name} $out/share/icons/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fuchsia Cursors";
    homepage = "https://github.com/ful1e5/fuchsia-cursor";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
