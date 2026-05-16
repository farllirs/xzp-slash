#!/usr/bin/env bash
# update-repo.sh — Generates APT repository metadata

set -e

# Use the current directory as the repo root
REPO_ROOT="."

echo "Generating Packages file..."
# Scan all .deb files and create the Packages index
dpkg-scanpackages --multiversion . > Packages
gzip -9c Packages > Packages.gz

echo "Generating Release file..."
cat <<EOF > Release
Origin: xzp-slash Repository
Label: xzp-slash
Suite: stable
Codename: xzp-slash
Architectures: all amd64
Components: main
Description: Official repository for xzp-slash
EOF

# Calculate hashes for the Release file
{
    echo "MD5Sum:"
    printf " $(md5sum Packages | cut -d' ' -f1) %16d Packages\n" $(stat -c%s Packages)
    printf " $(md5sum Packages.gz | cut -d' ' -f1) %16d Packages.gz\n" $(stat -c%s Packages.gz)
    echo "SHA1:"
    printf " $(sha1sum Packages | cut -d' ' -f1) %16d Packages\n" $(stat -c%s Packages)
    printf " $(sha1sum Packages.gz | cut -d' ' -f1) %16d Packages.gz\n" $(stat -c%s Packages.gz)
    echo "SHA256:"
    printf " $(sha256sum Packages | cut -d' ' -f1) %16d Packages\n" $(stat -c%s Packages)
    printf " $(sha256sum Packages.gz | cut -d' ' -f1) %16d Packages.gz\n" $(stat -c%s Packages.gz)
} >> Release

echo "Repository metadata updated successfully."
