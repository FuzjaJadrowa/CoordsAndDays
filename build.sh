#!/bin/bash
set -euo pipefail

# Config
VERSION="1.1.0+26.X"
PACK_DIR="pack"
BUILD_DIR="build"

cd "$(dirname "$0")"

FILE_VERSION="${VERSION//+/-}"
PACK_ZIP="${BUILD_DIR}/CoordsAndDays-pack-${FILE_VERSION}.zip"
MOD_JAR="${BUILD_DIR}/CoordsAndDays-fabric-${VERSION}.jar"

echo "Building CoordsAndDays packages (Version: ${VERSION})..."

if [ ! -f "$PACK_DIR/pack.mcmeta" ] || [ ! -d "$PACK_DIR/assets" ] || [ ! -d "$PACK_DIR/data" ]; then
    echo "Error: '$PACK_DIR' must contain pack.mcmeta, assets/ and data/."
    exit 1
fi

if [ ! -d "$BUILD_DIR" ]; then
    echo "Creating build directory..."
    mkdir -p "$BUILD_DIR"
fi

zip_folder_contents() {
    local src_dir="$1"
    local dest_zip="$2"
    
    if [ -f "$dest_zip" ]; then
        echo "Removing existing $dest_zip..."
        rm -f "$dest_zip"
    fi
    
    echo "Compressing contents of '$src_dir' into '$dest_zip'..."
    
    local abs_dest_zip
    abs_dest_zip="$(cd "$(dirname "$dest_zip")" && pwd)/$(basename "$dest_zip")"
    
    (cd "$src_dir" && zip -q -r "$abs_dest_zip" .)
}

zip_fabric_mod() {
    local pack_dir="$1"
    local dest_jar="$2"
    
    if [ -f "$dest_jar" ]; then
        echo "Removing existing $dest_jar..."
        rm -f "$dest_jar"
    fi
    
    echo "Building mod jar into '$dest_jar'..."
    
    local abs_dest_jar
    abs_dest_jar="$(cd "$(dirname "$dest_jar")" && pwd)/$(basename "$dest_jar")"
    
    local tmp_dir
    tmp_dir="$(mktemp -d)"
    
    if [ -f "fabric.mod.json" ]; then
        sed "s/\"version\":\s*\"[^\"]*\"/\"version\": \"${VERSION}\"/g" fabric.mod.json > "${tmp_dir}/fabric.mod.json"
    fi
    
    # Include pack.mcmeta and overlay directories as well as assets/ and data/.
    cp -r "${pack_dir}/." "$tmp_dir/"
    
    (cd "$tmp_dir" && zip -q -r "$abs_dest_jar" *)
    rm -rf "$tmp_dir"
}

if ! command -v zip &> /dev/null; then
    echo "Error: 'zip' command is not installed or not in PATH."
    echo "Please install 'zip' to build packages on this system."
    exit 1
fi

zip_folder_contents "$PACK_DIR" "$PACK_ZIP"
zip_fabric_mod "$PACK_DIR" "$MOD_JAR"

echo "Build completed! Output folder: $BUILD_DIR"