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
export PATH="${BIN_DIR}:${PATH}"

ensure_user_path() {
  local line='export PATH="$HOME/.local/bin:$PATH"'
  local rc
  for rc in \
    "${HOME}/.zprofile" \
    "${HOME}/.zshrc" \
    "${HOME}/.bash_profile" \
    "${HOME}/.bashrc" \
    "${HOME}/.profile"
  do
    if [[ -f "$rc" ]] && grep -qE '\.local/bin' "$rc" 2>/dev/null; then
      return 0
    fi
  done
  rc="${HOME}/.zprofile"
  [[ -f "${HOME}/.zshrc" && ! -f "$rc" ]] && rc="${HOME}/.zshrc"
  [[ ! -f "$rc" && -f "${HOME}/.bashrc" ]] && rc="${HOME}/.bashrc"
  [[ ! -f "$rc" ]] && rc="${HOME}/.profile"
  printf '\n# Holix Studio CE — holix CLI\n%s\n' "$line" >> "$rc"
  ok "PATH ${BIN_DIR} appended to ${rc}"
}

link_holix() {
  local src="$1"
  [[ -x "$src" ]] || return 1
  ln -sfn "$src" "${BIN_DIR}/holix"
  ok "Linked ${BIN_DIR}/holix"
  if [[ -w /usr/local/bin ]]; then
    ln -sfn "$src" /usr/local/bin/holix
    ok "Linked /usr/local/bin/holix"
  elif command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
    sudo ln -sfn "$src" /usr/local/bin/holix
    ok "Linked /usr/local/bin/holix (sudo)"
  fi
}

log "Venv ${VENV}"
uv venv --python 3.12 "$VENV"
# shellcheck disable=SC1091
source "${VENV}/bin/activate"

log "Installing ${HOLIX_PIN} into CE venv…"
uv pip install "${HOLIX_PIN}"

# User-global CLI so `holix models` / `holix bootstrap` work in any shell.
log "Installing Holix CLI globally (uv tool)…"
if uv tool install --force "${HOLIX_PIN}"; then
  TOOL_HOLIX="$(command -v holix || true)"
  ok "uv tool: ${TOOL_HOLIX:-holix}"
fi

HOLIX_BIN="$(command -v holix 2>/dev/null || true)"
if [[ -z "$HOLIX_BIN" || ! -x "$HOLIX_BIN" ]]; then
  HOLIX_BIN="${VENV}/bin/holix"
fi
link_holix "$HOLIX_BIN" || die "holix binary missing after install"
ensure_user_path

hash -r 2>/dev/null || true
if command -v holix >/dev/null 2>&1; then
  ok "holix is on PATH: $(command -v holix)"
  holix --help >/dev/null 2>&1 || true
else
  log "Open a new terminal, or: export PATH=\"${BIN_DIR}:\$PATH\""
fi

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
  echo "  Agent:  $(command -v holix 2>/dev/null || echo "${VENV}/bin/holix")"
  echo "  holix models setup"
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
echo "  holix version"
echo "  holix models setup"
echo "  holix-studio-ce setup"
echo "  holix-studio-ce serve"
echo "  open http://127.0.0.1:8788/studio/"
echo
echo "Then sign in (profile name + password printed once) and add a model:"
echo "  Admin → Models (or Settings → Models) → Add provider → API key."
echo "Guide: https://github.com/javded-itres/holix-studio-ce/blob/main/docs/en/SETUP.md"
echo "       https://github.com/javded-itres/holix-studio-ce/blob/main/docs/ru/SETUP.md"
echo "Cloud for teams: https://holix-studio.ru"
