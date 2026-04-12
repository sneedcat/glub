{ pkgs }:

let
  pname = "helium";
  version = "0.11.1.1";

  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    sha256 = "sha256-Nfi8qjj7YOujsf8nLm3Mu+oh/R642Wy/nnc0ToolpW0=";
  };

  appImageContents = pkgs.appimageTools.extract {
    inherit pname version src;
  };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs =
    pkgs: with pkgs; [
      libva
      pipewire
      mesa
      glib
      nss
      nspr
      atk
      at-spi2-atk
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      gtk3
      pango
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxscrnsaver
    ];

  extraInstallCommands = ''
    install -m 444 -D ${appImageContents}/${pname}.desktop $out/share/applications/${pname}.desktop

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}' \
      --replace 'Exec=helium' 'Exec=${pname}'

    install -m 444 -D ${appImageContents}/${pname}.png $out/share/icons/hicolor/512x512/apps/${pname}.png
  '';

  passthru = {
    updateScript = pkgs.nix-update-script {
      extraArgs = [
        "--flake"
        "--url"
        "https://github.com/imputnet/helium-linux"
      ];
    };
  };

  meta = {
    position = "${./helium.nix}:0";
  };
}
