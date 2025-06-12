#!/usr/bin/env bash
set -e

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  aarch64) ARCH="arm64" ;;
  riscv64) ARCH="riscv64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

PRJ=rsyncy
RELEASE_URL="https://github.com/laktak/$PRJ/releases/latest/download/$PRJ-$OS-$ARCH.tar.gz"
INSTALL_TO="$HOME/.local/bin"
BINARY="rsyncy"

mkdir -p "$INSTALL_TO"

# check if the release exists using a HEAD request
HTTP_STATUS=$(curl -I -L -s -o /dev/null -w "%{http_code}" "$RELEASE_URL")
if [ "$HTTP_STATUS" -ne 200 ]; then
  echo "Your OS/arch combination is not available as a binary on GitHub releases."
  echo "Please go to https://github.com/laktak/rsyncy and check for other setup methods"
  echo "or open an issue to request $OS-$ARCH support."
  exit 1
fi

echo "Downloading $PRJ from $RELEASE_URL"
curl -L "$RELEASE_URL" | tar -xz -C "$INSTALL_TO" "$BINARY"

chmod +x "$INSTALL_TO/$BINARY"

# check if ~/.local/bin is in the PATH
if ! echo "$PATH" | grep -q "$INSTALL_TO"; then
  echo "~/.local/bin is not in your PATH."
  echo "Add it by running the following command:"
  echo "echo 'export PATH=\"$INSTALL_TO:\$PATH\"' >> ~/.bashrc"
  echo "Then reload your shell with 'source ~/.bashrc'."
fi

echo "$BINARY is now available in $INSTALL_TO."
