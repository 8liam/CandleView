#!/bin/bash

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick is not installed. Installing via Homebrew..."
    brew install imagemagick
fi

# Source icon
SOURCE="CandleView/Assets.xcassets/AppIcon.appiconset/CandleView.png"
ICON_DIR="CandleView/Assets.xcassets/AppIcon.appiconset"

# Ensure source exists
if [ ! -f "$SOURCE" ]; then
    echo "Error: Source icon $SOURCE not found!"
    exit 1
fi

# Generate different sizes
declare -a SIZES=(16 32 64 128 256 512 1024)

for size in "${SIZES[@]}"; do
    echo "Generating ${size}x${size} icon..."
    convert "$SOURCE" -resize ${size}x${size} "$ICON_DIR/CandleView-${size}.png"
done

# Clean up any old mac_ prefixed files if they exist
rm -f "$ICON_DIR/mac_"*.png

echo "Icon resizing complete! All sizes are in $ICON_DIR"