#!/bin/bash

clear
echo ""
echo "  +==========================================+"
echo "  |     TradingView2Claude Connector        |"
echo "  |       Installazione automatica          |"
echo "  +==========================================+"
echo ""

REPO="itsmanuelbaby/tradingview2claude-connector"
VERSION="v1.0.0"

ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
  DMG_NAME="TradingView2Claude-1.0.0-arm64.dmg"
  echo "  -> Rilevato Mac Apple Silicon (M1/M2/M3/M4)"
else
  DMG_NAME="TradingView2Claude-1.0.0-x64.dmg"
  echo "  -> Rilevato Mac Intel"
fi

DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${DMG_NAME}"
DMG_PATH="$HOME/Downloads/$DMG_NAME"

echo ""
echo "  [1/4] Download in corso..."
curl -L -o "$DMG_PATH" "$DOWNLOAD_URL"

if [ ! -f "$DMG_PATH" ] || [ $(wc -c < "$DMG_PATH") -lt 1000000 ]; then
  echo ""
  echo "  X Download fallito. Verifica la connessione e riprova."
  exit 1
fi

echo ""
echo "  [2/4] Rimozione restrizioni macOS..."
xattr -cr "$DMG_PATH"

echo ""
echo "  [3/4] Installazione..."
hdiutil attach "$DMG_PATH" -nobrowse -quiet

APP_PATH=$(find /Volumes -name "TradingView2Claude Connector.app" 2>/dev/null | head -1)

if [ -z "$APP_PATH" ]; then
  echo "  X App non trovata nel DMG."
  exit 1
fi

mkdir -p ~/Applications
cp -r "$APP_PATH" ~/Applications/ 2>/dev/null || cp -r "$APP_PATH" /Applications/

INSTALLED_PATH="$HOME/Applications/TradingView2Claude Connector.app"
if [ ! -d "$INSTALLED_PATH" ]; then
  INSTALLED_PATH="/Applications/TradingView2Claude Connector.app"
fi

xattr -cr "$INSTALLED_PATH"

echo ""
echo "  [4/4] Pulizia..."
hdiutil detach "/Volumes/TradingView2Claude Connector" -quiet 2>/dev/null
rm -f "$DMG_PATH"

echo ""
echo "  Installazione completata!"
echo ""
echo "  Apertura TradingView2Claude Connector..."
sleep 1
open "$INSTALLED_PATH"
