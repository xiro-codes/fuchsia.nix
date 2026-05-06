{
  lib,
  stdenvNoCC,
  cbmp,
  clickgen,
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
    runHook preBuild

    # Generate custom render.json for the desired colors
    cat > render.json <<EOF
    {
      "${name}": {
        "dir": "svg",
        "out": "bitmaps/${name}",
        "colors": [
          { "match": "#00FF00", "replace": "${baseColor}" },
          { "match": "#0000FF", "replace": "${outlineColor}" }
        ]
      }
    }
    EOF

    # Render SVGs to bitmaps
    cbmp render.json

    # Build cursors using clickgen
    # Assuming x.build.toml is correctly set up for the basic build
    ctgen "configs/x.build.toml" -p x11 -d "bitmaps/${name}" -n "${name}" -c "${name} Cursors"

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
