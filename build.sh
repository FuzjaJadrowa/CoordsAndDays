#!/bin/bash

# Config
VERSION="1.0.0+26.3"
DATAPACK_DIR="datapack"
RESOURCEPACK_DIR="resourcepack"
BUILD_DIR="build"

cd "$(dirname "$0")"

DATAPACK_ZIP="${BUILD_DIR}/CoordsAndDays-datapack-${VERSION}.zip"
RESOURCEPACK_ZIP="${BUILD_DIR}/CoordsAndDays-resourcepack-${VERSION}.zip"

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

echo "Build completed! Output folder: $BUILD_DIR"