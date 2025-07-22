#!/bin/bash

# Release script for SparkReader Library
# Usage: ./release.sh <version>

set -euo pipefail

# Determine the repo root using git and switch to it
REPO_ROOT=$(git -C "$(dirname "$0")" rev-parse --show-toplevel)
cd "$REPO_ROOT"

# Script now always executes from the root of the repo
SCRIPT_DIR="$REPO_ROOT/scripts"
OUTPUT_DIR="$SCRIPT_DIR/output"
LIBRARY_DIR="$OUTPUT_DIR/library"
RELEASE_DIR="$REPO_ROOT/release"
VERSION_JSON_FILE="$REPO_ROOT/VERSION.json"

echo "Releasing SparkReader Library from $LIBRARY_DIR"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 1.2.0"
    exit 1
fi

VERSION="$1"
RELEASE_DATE=$(date +%F)
ZIP_FILE="$RELEASE_DIR/library-${VERSION}.zip"
VERSION_FILE="$LIBRARY_DIR/VERSION"

# Validate semantic version format
if ! echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    echo "❗ Error: Version must be in semantic version format (e.g., 1.2.0)"
    exit 1
fi

# Create VERSION file
mkdir -p "$LIBRARY_DIR"
echo "$VERSION" > "$VERSION_FILE"

# Validate catalog
echo "Validating catalog..."
python "$SCRIPT_DIR/validate_catalog.py" --tags "$REPO_ROOT/tags/tags.txt" --catalog "$LIBRARY_DIR/catalog.json" || {
    echo "❗ Erorr: Catalog validation failed. Aborting."
    exit 1
}

# Make sure tags_for_app.txt are current
while IFS= read -r line_a; do
    # Use grep to check exact match or prefix followed by slash
    if ! grep -q -x "$line_a" "$REPO_ROOT/tags/tags.txt" && ! grep -q "^${line_a}/" "$REPO_ROOT/tags/tags.txt"; then
        echo "❗ Error: Tag $line_a from tags/tags_for_app.txt missing from tags/tags.txt. Aborting."
        exit 1
    fi
done < "$REPO_ROOT/tags/tags_for_app.txt"

cp "$REPO_ROOT/tags/tags_for_app.txt" "$LIBRARY_DIR/tags.txt"

# Create ZIP package
echo "Creating library package..."
cd "$OUTPUT_DIR"
zip -9r "library-${VERSION}.zip" library/ > /dev/null
cd "$REPO_ROOT"

# Move ZIP to release directory
mkdir -p "$RELEASE_DIR"
mv "$OUTPUT_DIR/library-${VERSION}.zip" "$ZIP_FILE"

# Compute size and checksum
SIZE_BYTES=$(stat -c%s "$ZIP_FILE")
CHECKSUM=$(sha256sum "$ZIP_FILE" | awk '{print $1}')

# Create VERSION.json
# TODO: use changelog to populate "changes" field
echo "Creating VERSION.json..."
cat > "$VERSION_JSON_FILE" <<EOF
{
  "version": "$VERSION",
  "date": "$RELEASE_DATE",
  "changes": "",
  "sizeInBytes": $SIZE_BYTES,
  "sha256sum": "$CHECKSUM"
}
EOF

# Git operations
echo "Committing and pushing release..."
git add "$ZIP_FILE" "$VERSION_JSON_FILE"
git commit -m "Release SparkReader Library v${VERSION}"
git push

echo "Successfully released library v${VERSION}"
