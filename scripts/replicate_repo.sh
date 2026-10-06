#!/usr/bin/env bash

set -euo pipefail

DEST_OWNER="TranNguyenVu-code"
AUTHOR_NAME="TranNguyenVu-code"
AUTHOR_EMAIL="trannguyenvu0102@gmail.com"

usage() {
  cat <<'EOF'
Usage:
  scripts/replicate_repo.sh <source-owner/source-repo> [options]

Options:
  --directory <path>  Local destination (default: ./replicas/<repo>)
  --update            Update an existing destination repository with a new
                      snapshot. Source history is never copied; destination
                      snapshot history is retained.
  --private           Create a private destination instead of a public one.
  -h, --help          Show this help.

Examples:
  scripts/replicate_repo.sh nhamhung/energy-demand-forecasting
  scripts/replicate_repo.sh https://github.com/nhamhung/energy-demand-forecasting --update
EOF
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

normalize_repo() {
  local value="$1"
  value="${value#https://github.com/}"
  value="${value#http://github.com/}"
  value="${value#git@github.com:}"
  value="${value%.git}"
  value="${value%/}"
  printf '%s' "$value"
}

SOURCE_INPUT="${1:-}"
[[ -n "$SOURCE_INPUT" ]] || { usage; exit 2; }
[[ "$SOURCE_INPUT" != "-h" && "$SOURCE_INPUT" != "--help" ]] || { usage; exit 0; }
shift

UPDATE=false
VISIBILITY="--public"
LOCAL_DIR=""

while (($#)); do
  case "$1" in
    --directory)
      (($# >= 2)) || die "--directory requires a path"
      LOCAL_DIR="$2"
      shift 2
      ;;
    --update)
      UPDATE=true
      shift
      ;;
    --private)
      VISIBILITY="--private"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unknown option: $1"
      ;;
  esac
done

require_command git
require_command gh
require_command curl
require_command tar

SOURCE_REPO="$(normalize_repo "$SOURCE_INPUT")"
[[ "$SOURCE_REPO" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || \
  die "Source must be owner/repository or a GitHub repository URL"

REPO_NAME="${SOURCE_REPO#*/}"
DEST_REPO="${DEST_OWNER}/${REPO_NAME}"
LOCAL_DIR="${LOCAL_DIR:-$PWD/replicas/$REPO_NAME}"
LOCAL_DIR="${LOCAL_DIR%/}"

printf 'Switching GitHub CLI authentication to %s...\n' "$DEST_OWNER"
gh auth switch --hostname github.com --user "$DEST_OWNER" >/dev/null 2>&1 || \
  die "${DEST_OWNER} is not authenticated in GitHub CLI. Run: gh auth login --hostname github.com --web"
gh auth setup-git >/dev/null

ACTIVE_USER="$(gh api user --jq .login)"
ACTIVE_USER_LOWER="$(printf '%s' "$ACTIVE_USER" | tr '[:upper:]' '[:lower:]')"
DEST_OWNER_LOWER="$(printf '%s' "$DEST_OWNER" | tr '[:upper:]' '[:lower:]')"
[[ "$ACTIVE_USER_LOWER" == "$DEST_OWNER_LOWER" ]] || \
  die "Active GitHub account is ${ACTIVE_USER}, expected ${DEST_OWNER}"

DEFAULT_BRANCH="$(gh api "repos/${SOURCE_REPO}" --jq .default_branch)"
[[ -n "$DEFAULT_BRANCH" ]] || die "Could not determine the source default branch"

TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/repo-replica.XXXXXX")"
trap 'rm -rf "$TEMP_DIR"' EXIT
SNAPSHOT_DIR="$TEMP_DIR/snapshot"
mkdir -p "$SNAPSHOT_DIR"

printf 'Downloading %s@%s without Git history...\n' "$SOURCE_REPO" "$DEFAULT_BRANCH"
curl --fail --location --silent --show-error \
  "https://api.github.com/repos/${SOURCE_REPO}/tarball/${DEFAULT_BRANCH}" \
  --output "$TEMP_DIR/source.tar.gz"
tar -xzf "$TEMP_DIR/source.tar.gz" --strip-components=1 -C "$SNAPSHOT_DIR"
[[ -f "$SNAPSHOT_DIR/.github/workflows/pages.yml" ]] || \
  die "The source has no .github/workflows/pages.yml deployment workflow"

DEST_EXISTS=false
if gh api "repos/${DEST_REPO}" >/dev/null 2>&1; then
  DEST_EXISTS=true
fi

if [[ "$DEST_EXISTS" == true && "$UPDATE" != true ]]; then
  die "${DEST_REPO} already exists. Re-run with --update to publish a new snapshot commit."
fi

if [[ "$DEST_EXISTS" == true ]]; then
  printf 'Preparing existing destination %s...\n' "$DEST_REPO"
  if [[ -d "$LOCAL_DIR/.git" ]]; then
    [[ -z "$(git -C "$LOCAL_DIR" status --porcelain)" ]] || \
      die "Local destination has uncommitted changes: ${LOCAL_DIR}"
    git -C "$LOCAL_DIR" remote set-url origin "https://github.com/${DEST_REPO}.git"
    git -C "$LOCAL_DIR" fetch origin main
    git -C "$LOCAL_DIR" switch main
    git -C "$LOCAL_DIR" merge --ff-only origin/main
  elif [[ -e "$LOCAL_DIR" ]]; then
    die "Local destination exists but is not a Git repository: ${LOCAL_DIR}"
  else
    mkdir -p "$(dirname "$LOCAL_DIR")"
    git clone "https://github.com/${DEST_REPO}.git" "$LOCAL_DIR"
  fi

  git -C "$LOCAL_DIR" rm -r -q --ignore-unmatch .
  cp -R "$SNAPSHOT_DIR/." "$LOCAL_DIR/"
else
  [[ ! -e "$LOCAL_DIR" ]] || die "Local destination already exists: ${LOCAL_DIR}"
  mkdir -p "$(dirname "$LOCAL_DIR")"
  mkdir "$LOCAL_DIR"
  cp -R "$SNAPSHOT_DIR/." "$LOCAL_DIR/"
  git -C "$LOCAL_DIR" init -b main
fi

git -C "$LOCAL_DIR" config --local user.name "$AUTHOR_NAME"
git -C "$LOCAL_DIR" config --local user.email "$AUTHOR_EMAIL"
git -C "$LOCAL_DIR" add -A

if git -C "$LOCAL_DIR" diff --cached --quiet; then
  printf 'Destination already matches the source snapshot; no commit needed.\n'
else
  git -C "$LOCAL_DIR" commit -m "Import snapshot from ${SOURCE_REPO}"
fi

if [[ "$DEST_EXISTS" != true ]]; then
  printf 'Creating %s...\n' "$DEST_REPO"
  gh repo create "$DEST_REPO" "$VISIBILITY" \
    --description "History-free snapshot of ${SOURCE_REPO}"
  git -C "$LOCAL_DIR" remote add origin "https://github.com/${DEST_REPO}.git"
fi

printf 'Pushing main to %s...\n' "$DEST_REPO"
git -C "$LOCAL_DIR" push --set-upstream origin main
HEAD_SHA="$(git -C "$LOCAL_DIR" rev-parse HEAD)"

printf 'Enabling GitHub Pages with the Actions deployment workflow...\n'
if gh api "repos/${DEST_REPO}/pages" >/dev/null 2>&1; then
  gh api --method PUT "repos/${DEST_REPO}/pages" -f build_type=workflow >/dev/null
else
  gh api --method POST "repos/${DEST_REPO}/pages" -f build_type=workflow >/dev/null
fi

DISPATCHED=false
for _ in 1 2 3 4 5 6; do
  if gh workflow run pages.yml --repo "$DEST_REPO" --ref main >/dev/null 2>&1; then
    DISPATCHED=true
    break
  fi
  sleep 5
done
[[ "$DISPATCHED" == true ]] || die "Pages workflow was not available after the push"

RUN_ID=""
for _ in 1 2 3 4 5 6 7 8 9 10 11 12; do
  RUN_ID="$(gh run list --repo "$DEST_REPO" --workflow pages.yml \
    --event workflow_dispatch --branch main --commit "$HEAD_SHA" --limit 1 \
    --json databaseId --jq '.[0].databaseId // empty')"
  [[ -n "$RUN_ID" ]] && break
  sleep 5
done
[[ -n "$RUN_ID" ]] || die "Could not find the dispatched Pages workflow run"

printf 'Waiting for GitHub Pages deployment (run %s)...\n' "$RUN_ID"
gh run watch "$RUN_ID" --repo "$DEST_REPO" --exit-status

PAGES_URL="$(gh api "repos/${DEST_REPO}/pages" --jq .html_url)"

printf '\nReplication complete.\n'
printf 'Repository: https://github.com/%s\n' "$DEST_REPO"
printf 'GitHub Pages: %s\n' "$PAGES_URL"
printf 'Local copy: %s\n' "$LOCAL_DIR"
printf 'Commit author: %s <%s>\n' "$AUTHOR_NAME" "$AUTHOR_EMAIL"
