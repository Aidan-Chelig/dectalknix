{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/4fe8d07066f6ea82cda2b0c9ae7aee59b2d241b3.tar.gz";
    sha256 = "sha256:06jzngg5jm1f81sc4xfskvvgjy5bblz51xpl788mnps1wrkykfhp";
  }) {}
}:
pkgs.stdenv.mkDerivation rec {
  pname = "dectalk";
  version = "2023-10-30";

  src = pkgs.fetchgit {
    url = "https://github.com/dectalk/dectalk";
    rev = "cde003e85ea60ffa355c8adcdd35e01132b851d6";
    sha256 = "sha256-caA6VvdKCJHo3rC7gD07tSTEx9uKeovYBQ1i5aRWFsk=";
  };

  buildInputs = with pkgs; [
    git
    gcc
    automake
    unzip
    autoconf
    pkg-config
  ];

  nativeBuildInputs = with pkgs; [
    alsaLib
    libpulseaudio
    gtk2-x11
    file
  ];

  configurePhase = ''
    srcdir=$(pwd)/
    cd src
    autoreconf -si
    ./configure 
    cd ..
  '';

  buildPhase = ''
  cd ./src
  make -j 
  cd ../
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share
    mkdir -p $out/opt/dectalk/

     mv ./dist/lib/ $out/
     mv ./dist/doc/DECtalk/man $out
     mv ./dist/* $out/opt/dectalk/
      #mv $(file ./* | grep "ELF" | awk '{print $1}' | tr -d ":" | tr "\n" " ") $out/bin/


      mv ./dist $out/
  '';
}
