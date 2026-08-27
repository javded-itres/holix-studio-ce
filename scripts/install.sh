#!/usr/bin/env bash
# Holix Studio CE landing — install the Holix agent (single-user companion).
# Studio IDE CE wheel, when published, will be installed from GitHub Releases.
set -euo pipefail

HOLIX_PIN="${HOLIX_PIN:-Holix==1.1.0}"

log() { printf '→ %s\n' "$*"; }
ok()  { printf '✓ %s\n' "$*"; }
die() { printf '✗ %s\n' "$*" >&2; exit 1; }

if ! command -v uv >/dev/null 2>&1; then
  die "Install uv first: https://docs.astral.sh/uv/  (curl -LsSf https://astral.sh/uv/install.sh | sh)"
fi

log "Installing ${HOLIX_PIN} with uv tool…"
uv tool install --python 3.12 "${HOLIX_PIN}" || uv tool install "${HOLIX_PIN}"

if command -v holix >/dev/null 2>&1; then
  ok "holix $(holix --version 2>/dev/null || echo ready)"
else
  ok "Holix installed. Ensure uv tool bin is on PATH (usually ~/.local/bin)"
fi

echo
echo "Holix agent is ready (MIT)."
echo "  holix                 # TUI"
echo "  holix --help"
echo
echo "Set a model key in the Holix profile, then come back for Studio CE IDE"
echo "releases on this repo: https://github.com/javded-itres/holix-studio-ce"
echo "Cloud for teams: https://holix-studio.ru"
