#!/bin/bash

# Config
VERSION="1.0.1+26.3"
DATAPACK_DIR="datapack"
RESOURCEPACK_DIR="resourcepack"
BUILD_DIR="build"

cd "$(dirname "$0")"

DATAPACK_ZIP="${BUILD_DIR}/CoordsAndDays-datapack-${VERSION}.zip"
RESOURCEPACK_ZIP="${BUILD_DIR}/CoordsAndDays-resourcepack-${VERSION}.zip"
MOD_JAR="${BUILD_DIR}/CoordsAndDays-fabric-${VERSION}.jar"

echo "Building CoordsAndDays packages (Version: ${VERSION})..."

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
    
    (cd "$src_dir" && zip -q -r "$abs_dest_zip" *)
}

zip_fabric_mod() {
    local datapack_dir="$1"
    local resourcepack_dir="$2"
    local dest_jar="$3"
    
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
    
    if [ -f "${resourcepack_dir}/pack.png" ]; then
        cp "${resourcepack_dir}/pack.png" "${tmp_dir}/pack.png"
    fi
    
    if [ -d "${datapack_dir}/data" ]; then
        mkdir -p "${tmp_dir}/data"
        cp -r "${datapack_dir}/data/"* "${tmp_dir}/data/"
    fi
    
    if [ -d "${resourcepack_dir}/assets" ]; then
        mkdir -p "${tmp_dir}/assets"
        cp -r "${resourcepack_dir}/assets/"* "${tmp_dir}/assets/"
    fi
    
    (cd "$tmp_dir" && zip -q -r "$abs_dest_jar" *)
    rm -rf "$tmp_dir"
}

if ! command -v zip &> /dev/null; then
    echo "Error: 'zip' command is not installed or not in PATH."
    echo "Please install 'zip' to build packages on this system."
    exit 1
fi

if [ -d "$DATAPACK_DIR" ]; then
    zip_folder_contents "$DATAPACK_DIR" "$DATAPACK_ZIP"
else
    echo "Warning: Datapack directory not found at $DATAPACK_DIR"
fi

if [ -d "$RESOURCEPACK_DIR" ]; then
    zip_folder_contents "$RESOURCEPACK_DIR" "$RESOURCEPACK_ZIP"
else
    echo "Warning: Resourcepack directory not found at $RESOURCEPACK_DIR"
fi

if [ -d "$DATAPACK_DIR" ] && [ -d "$RESOURCEPACK_DIR" ]; then
    zip_fabric_mod "$DATAPACK_DIR" "$RESOURCEPACK_DIR" "$MOD_JAR"
else
    echo "Warning: Cannot build Fabric mod because datapack or resourcepack directory is missing."
fi

echo "Build completed! Output folder: $BUILD_DIR"