#!/bin/bash
set -e

echo "Building AIQueryTranslator..."
cd AIQueryTranslator
swift build -c release
cd ..

echo "Copying binary to bundle..."
mkdir -p AIQuery.mmBundle/Support/bin
cp AIQueryTranslator/.build/release/AIQueryTranslator AIQuery.mmBundle/Support/bin/

echo "Build complete. Artifact is in AIQuery.mmBundle"
