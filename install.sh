#!/bin/bash
set -e

BUNDLE_NAME="AIQuery.mmBundle"
DEST="$HOME/Library/Application Support/MailMate/Bundles"

if [ ! -d "$DEST" ]; then
    echo "MailMate Bundles directory not found at $DEST"
    echo "Creating it..."
    mkdir -p "$DEST"
fi

echo "Installing $BUNDLE_NAME to $DEST..."
rm -rf "$DEST/$BUNDLE_NAME"
cp -R "$BUNDLE_NAME" "$DEST/"

echo "Installation complete."
echo "Please restart MailMate to load the new bundle."
echo "You can trigger the command via Command-Ctrl-S (if configured) or from the Command menu."
