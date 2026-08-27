#!/usr/bin/env bash
# Install Holix agent + Holix Studio CE (single-user IDE) into a local venv.
set -euo pipefail

HOLIX_PIN="${HOLIX_PIN:-Holix==1.1.0}"
CE_REPO="${CE_REPO:-javded-itres/holix-studio-ce}"
PREFIX="${HOLIX_STUDIO_PREFIX:-${HOME}/.local/share/holix-studio-ce}"
BIN_DIR="${HOLIX_STUDIO_BIN:-${HOME}/.local/bin}"
VENV="${PREFIX}/venv"

log() { printf '→ %s\n' "$*"; }
ok()  { printf '✓ %s\n' "$*"; }
die() { printf '✗ %s\n' "$*" >&2; exit 1; }

if ! command -v uv >/dev/null 2>&1; then
  die "Install uv: https://docs.astral.sh/uv/   curl -LsSf https://astral.sh/uv/install.sh | sh"
fi
command -v python3 >/dev/null || die "python3 is required"

mkdir -p "$PREFIX" "$BIN_DIR"
log "Venv ${VENV}"
uv venv --python 3.12 "$VENV"
# shellcheck disable=SC1091
source "${VENV}/bin/activate"

log "Installing ${HOLIX_PIN}…"
uv pip install "${HOLIX_PIN}"

WHEEL_URL="$(python3 - <<PY
import json, sys, urllib.request
url = "https://api.github.com/repos/${CE_REPO}/releases/latest"
try:
    req = urllib.request.Request(url, headers={"User-Agent": "holix-studio-ce-install"})
    with urllib.request.urlopen(req, timeout=30) as r:
        data = json.load(r)
except Exception as exc:
    print("", end="")
    sys.exit(0)
for a in data.get("assets") or []:
    name = a.get("name") or ""
    if name.endswith(".whl"):
        print(a.get("browser_download_url") or "")
        break
PY
)"

if [[ -z "${WHEEL_URL}" ]]; then
  echo
  echo "! No Studio CE wheel on GitHub Releases yet."
  echo "  Holix agent is installed. IDE wheel is published from the private"
  echo "  Studio repo (Actions: Publish CE wheel) onto:"
  echo "  https://github.com/${CE_REPO}/releases"
  echo
  echo "  Agent:  ${VENV}/bin/holix"
  exit 0
fi

log "Installing Studio from ${WHEEL_URL}"
uv pip install "${WHEEL_URL}"

CE_BIN="${VENV}/bin/holix-studio-ce"
if [[ -x "$CE_BIN" ]]; then
  ln -sfn "$CE_BIN" "${BIN_DIR}/holix-studio-ce"
  ok "Linked ${BIN_DIR}/holix-studio-ce"
else
  die "holix-studio-ce entry point missing in the wheel"
fi

echo
ok "Holix Studio CE is installed (single-user)."
echo "  export PATH=\"${BIN_DIR}:\$PATH\""
echo "  holix-studio-ce setup"
echo "  holix-studio-ce serve"
echo "  open http://127.0.0.1:8788/studio/"
echo
echo "Model key: configure Holix profile (OPENAI_API_KEY or LiteLLM)."
echo "Cloud for teams: https://holix-studio.ru"
