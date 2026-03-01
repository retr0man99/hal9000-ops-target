#!/usr/bin/env zsh
# ─────────────────────────────────────────────────────────────────────────────
# push-to-github.sh — fully zsh-native, no bash-isms
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

REPO_NAME="hal9000-ops-target"

# zsh: get script directory without BASH_SOURCE
SCRIPT_DIR="${0:A:h}"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { print -P "%F{green}▶ $1%f"; }
warn()  { print -P "%F{yellow}⚠  $1%f"; }
error() { print -P "%F{red}✖ $1%f"; exit 1; }

# ── Check dependencies ────────────────────────────────────────────────────────
info "Checking dependencies..."
command -v git >/dev/null 2>&1 || error "git not found. Install: brew install git"
command -v gh  >/dev/null 2>&1 || error "gh not found. Install: brew install gh && gh auth login"

if ! gh auth status >/dev/null 2>&1; then
  error "GitHub CLI not authenticated. Run: gh auth login"
fi

# ── Get GitHub username ───────────────────────────────────────────────────────
if [[ $# -gt 0 ]]; then
  GH_USER="$1"
else
  GH_USER=$(gh api user --jq '.login')
fi

info "GitHub user: ${GH_USER}"
info "Repo will be: ${GH_USER}/${REPO_NAME}"
echo ""

# ── Confirm — zsh native read (no -p flag) ────────────────────────────────────
print -n "${YELLOW}Create and push ${GH_USER}/${REPO_NAME}? [y/N] ${NC}"
read confirm
[[ "${confirm:l}" == "y" ]] || { warn "Aborted."; exit 0; }
echo ""

# ── Move into project directory ───────────────────────────────────────────────
cd "$SCRIPT_DIR"

# ── Init git ──────────────────────────────────────────────────────────────────
info "Initialising git repository..."
git init
git checkout -b main 2>/dev/null || git checkout main

# ── Stage & commit ────────────────────────────────────────────────────────────
info "Staging files..."
git add .
git status --short

info "Creating initial commit..."
git commit -m "feat: initial hal9000-ops-target project

- Python Flask app with health/ping endpoints
- Multi-stage Dockerfile with non-root user and HEALTHCHECK
- Working CI workflow: test -> lint -> docker build
- Intentionally broken CI workflow for HAL9000-OPS agent testing
- Pytest suite with 80% coverage gate
- docker-compose for local dev" 2>/dev/null || warn "Nothing new to commit — continuing..."

# ── Create GitHub repo ────────────────────────────────────────────────────────
info "Creating GitHub repository ${GH_USER}/${REPO_NAME}..."

if gh repo view "${GH_USER}/${REPO_NAME}" >/dev/null 2>&1; then
  warn "Repo already exists — skipping creation..."
else
  gh repo create "${REPO_NAME}" \
    --public \
    --description "Dummy Flask CI target for HAL9000-OPS agent testing"
fi

# ── Remote & push ─────────────────────────────────────────────────────────────
info "Setting remote origin..."
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "https://github.com/${GH_USER}/${REPO_NAME}.git"
else
  git remote add origin "https://github.com/${GH_USER}/${REPO_NAME}.git"
fi

info "Pushing to GitHub..."
git push -u origin main

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
print -P "%F{green}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%f"
print -P "%F{green}  ✅  hal9000-ops-target pushed successfully!%f"
print -P "%F{green}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%f"
echo ""
print -P "  Repo URL : %F{yellow}https://github.com/${GH_USER}/${REPO_NAME}%f"
print -P "  Actions  : %F{yellow}https://github.com/${GH_USER}/${REPO_NAME}/actions%f"
echo ""
print -P "  Next steps:"
print -P "  1. Open Actions tab — ci-broken.yml will have already failed ✓"
print -P "  2. Get the failed run ID from the URL bar"
print -P "  3. Set HAL9000-OPS .env:  %F{yellow}GITHUB_REPO=${GH_USER}/${REPO_NAME}%f"
print -P "  4. Run: %F{yellow}python -m agent.brain ${GH_USER}/${REPO_NAME} <run_id> main%f"
echo ""