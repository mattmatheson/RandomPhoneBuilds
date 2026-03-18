#!/bin/bash
# =============================================================================
# Claude Code Windows WSL2 Setup Script
# For Matt Matheson's portable dev environment
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Helpers
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }
step()    { echo -e "\n${CYAN}${BOLD}>>> $1${NC}"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BOLD}${CYAN}"
echo "============================================="
echo "  Claude Code WSL2 Setup"
echo "  Matt Matheson's Portable Dev Environment"
echo "============================================="
echo -e "${NC}"

# ---- Step 0: WSL Check ----
step "Checking if running in WSL..."

if grep -qEi "(microsoft|wsl)" /proc/version 2>/dev/null; then
    success "Running in WSL2 - good to go."
elif [ -f /proc/sys/fs/binfmt_misc/WSLInterop ] 2>/dev/null; then
    success "Running in WSL2 - good to go."
else
    warn "This doesn't look like WSL2. Script is designed for WSL but will continue anyway."
    echo -e "    Press Ctrl+C to abort, or wait 5 seconds to continue..."
    sleep 5
fi

# ---- Step 1: Node.js via nvm ----
step "Checking Node.js..."

# Source nvm if it exists
export NVM_DIR="${HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

if command -v node &>/dev/null; then
    NODE_VERSION=$(node --version)
    NODE_MAJOR=$(echo "$NODE_VERSION" | sed 's/v//' | cut -d. -f1)
    if [ "$NODE_MAJOR" -ge 20 ]; then
        success "Node.js $NODE_VERSION already installed (>= 20). Skipping."
    else
        warn "Node.js $NODE_VERSION found but need 20+. Installing via nvm..."
        if ! command -v nvm &>/dev/null; then
            info "Installing nvm first..."
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
            export NVM_DIR="${HOME}/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        fi
        nvm install 20
        nvm use 20
        nvm alias default 20
        success "Node.js $(node --version) installed via nvm."
    fi
else
    info "Node.js not found. Installing nvm + Node.js 20..."
    if ! command -v nvm &>/dev/null; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
        export NVM_DIR="${HOME}/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    fi
    nvm install 20
    nvm use 20
    nvm alias default 20
    success "Node.js $(node --version) installed via nvm."
fi

# ---- Step 2: Claude Code ----
step "Checking Claude Code..."

if command -v claude &>/dev/null; then
    success "Claude Code already installed. Skipping."
else
    info "Installing Claude Code globally..."
    npm install -g @anthropic-ai/claude-code
    if command -v claude &>/dev/null; then
        success "Claude Code installed successfully."
    else
        error "Claude Code installation may have failed. Check npm output above."
    fi
fi

# ---- Step 3: Firecrawl CLI ----
step "Checking Firecrawl CLI..."

if npm list -g firecrawl &>/dev/null 2>&1; then
    success "Firecrawl already installed. Skipping."
else
    info "Installing Firecrawl CLI globally..."
    npm install -g firecrawl
    success "Firecrawl CLI installed."
fi

# ---- Step 4: Restore Claude Config ----
step "Restoring Claude configuration from backup..."

BACKUP_FILE="${SCRIPT_DIR}/claude-config-backup.tar.gz"

if [ ! -f "$BACKUP_FILE" ]; then
    error "Backup file not found at $BACKUP_FILE"
    error "Make sure claude-config-backup.tar.gz is in the same directory as this script."
    exit 1
fi

if [ -d "$HOME/.claude" ]; then
    warn "~/.claude/ already exists!"
    echo -e "    ${YELLOW}Overwrite with backup? This will replace your current config.${NC}"
    read -rp "    [y/N]: " CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
        info "Backing up existing ~/.claude/ to ~/.claude.bak.$(date +%s)..."
        mv "$HOME/.claude" "$HOME/.claude.bak.$(date +%s)"
        info "Extracting backup..."
        mkdir -p "$HOME/.claude"
        tar xzf "$BACKUP_FILE" -C "$HOME/"
        success "Claude config restored from backup."
    else
        info "Skipping config restore. Existing ~/.claude/ left untouched."
    fi
else
    info "Extracting backup to ~/.claude/..."
    tar xzf "$BACKUP_FILE" -C "$HOME/"
    success "Claude config restored from backup."
fi

# ---- Step 5: Git Config ----
step "Setting up git config..."

CURRENT_NAME=$(git config --global user.name 2>/dev/null || echo "")
CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

if [ "$CURRENT_NAME" = "Matt Matheson" ] && [ "$CURRENT_EMAIL" = "mattmathesondotcom@gmail.com" ]; then
    success "Git config already set. Skipping."
else
    if [ -n "$CURRENT_NAME" ] || [ -n "$CURRENT_EMAIL" ]; then
        warn "Existing git config: name='$CURRENT_NAME' email='$CURRENT_EMAIL'"
        echo -e "    ${YELLOW}Overwrite with Matt Matheson / mattmathesondotcom@gmail.com?${NC}"
        read -rp "    [y/N]: " CONFIRM
        if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
            info "Skipping git config."
        else
            git config --global user.name "Matt Matheson"
            git config --global user.email "mattmathesondotcom@gmail.com"
            success "Git config updated."
        fi
    else
        git config --global user.name "Matt Matheson"
        git config --global user.email "mattmathesondotcom@gmail.com"
        success "Git config set: Matt Matheson / mattmathesondotcom@gmail.com"
    fi
fi

# ---- Step 6: Create sync script ----
step "Creating ~/.claude/sync.sh..."

SYNC_SCRIPT="$HOME/.claude/sync.sh"

cat > "$SYNC_SCRIPT" << 'SYNCEOF'
#!/bin/bash
# Claude Config Sync Script
# Commits memory/config changes and syncs with remote

set -e

CLAUDE_DIR="$HOME/.claude"
cd "$CLAUDE_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}Syncing Claude config...${NC}"

# Initialize git repo if needed
if [ ! -d .git ]; then
    echo -e "${YELLOW}Initializing git repo in ~/.claude/...${NC}"
    git init
    echo "# Claude Code Config" > README.md
    # Default gitignore - skip large/transient stuff
    cat > .gitignore << 'GIEOF'
cache/
sessions/
debug/
downloads/
paste-cache/
session-env/
shell-snapshots/
telemetry/
history.jsonl
*.tar.gz
GIEOF
    git add -A
    git commit -m "Initial Claude config commit"
    echo -e "${YELLOW}NOTE: Add a remote with: git remote add origin <your-repo-url>${NC}"
    echo -e "${YELLOW}Then run this script again to push.${NC}"
    exit 0
fi

# Stage changes
git add -A

# Check for changes
if git diff --cached --quiet; then
    echo -e "${GREEN}No changes to sync.${NC}"
else
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    git commit -m "Sync Claude config - $TIMESTAMP"
    echo -e "${GREEN}Changes committed.${NC}"
fi

# Push/pull if remote exists
if git remote get-url origin &>/dev/null; then
    BRANCH=$(git branch --show-current)
    echo -e "${CYAN}Pulling latest from origin/$BRANCH...${NC}"
    git pull --rebase origin "$BRANCH" 2>/dev/null || echo -e "${YELLOW}Pull failed (maybe no upstream yet). Trying push...${NC}"
    echo -e "${CYAN}Pushing to origin/$BRANCH...${NC}"
    git push -u origin "$BRANCH" 2>/dev/null || echo -e "${YELLOW}Push failed. You may need to set up the remote.${NC}"
    echo -e "${GREEN}Sync complete!${NC}"
else
    echo -e "${YELLOW}No git remote configured. Add one with:${NC}"
    echo -e "  cd ~/.claude && git remote add origin <your-repo-url>"
fi
SYNCEOF

chmod +x "$SYNC_SCRIPT"
success "Sync script created at ~/.claude/sync.sh"

# ---- Done! ----
echo ""
echo -e "${BOLD}${GREEN}=============================================${NC}"
echo -e "${BOLD}${GREEN}  Setup Complete!${NC}"
echo -e "${BOLD}${GREEN}=============================================${NC}"
echo ""
echo -e "${BOLD}${YELLOW}Manual steps remaining:${NC}"
echo ""
echo -e "  ${CYAN}1.${NC} Log in to Anthropic:  ${BOLD}claude${NC}  (follow the auth flow)"
echo -e "  ${CYAN}2.${NC} Reconnect MCP OAuth integrations (Gmail, Calendar, Notion, Canva)"
echo -e "     Run: ${BOLD}claude mcp list${NC} to see what's configured"
echo -e "     Then re-auth each one as needed"
echo -e "  ${CYAN}3.${NC} Set up GitHub SSH key for this machine if not already done:"
echo -e "     ${BOLD}ssh-keygen -t ed25519 -C \"mattmathesondotcom@gmail.com\"${NC}"
echo -e "     ${BOLD}cat ~/.ssh/id_ed25519.pub${NC}  (add to github.com/settings/keys)"
echo -e "  ${CYAN}4.${NC} Clone key repos:"
echo -e "     ${BOLD}git clone git@github.com:mattmatheson/RandomPhoneBuilds.git ~/RandomPhoneBuilds${NC}"
echo -e "  ${CYAN}5.${NC} Set up sync remote for Claude config (optional):"
echo -e "     ${BOLD}cd ~/.claude && git remote add origin <private-repo-url>${NC}"
echo -e "     ${BOLD}~/.claude/sync.sh${NC}"
echo -e "  ${CYAN}6.${NC} Update paths in CLAUDE.md and memory files if needed"
echo -e "     (macOS paths like /Users/matthewmatheson -> WSL /home/<user>)"
echo -e "  ${CYAN}7.${NC} Install Windows Terminal + Ghostty or preferred terminal"
echo ""
echo -e "${GREEN}You're ready to go. Run ${BOLD}claude${NC}${GREEN} to start!${NC}"
