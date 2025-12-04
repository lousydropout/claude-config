# Claude User Isolation: Protecting Sensitive Files

## Problem

When running Claude Code (or similar AI coding assistants), you may want to:
- Allow Claude to use shell commands freely (`cat`, `less`, `head`, `grep`, etc.)
- Prevent Claude from reading sensitive files (`.env`, credentials, secrets)
- Maintain normal workflow where you can still access everything

## Approach

Use Unix user/group permissions to enforce file access at the kernel level.

**Key insight:** Run Claude as a separate user (`claude`) that shares your primary group. This provides:
- Kernel-enforced access control (no command wrapper bypasses)
- Shared group means Claude can read/write most project files
- Owner-only permissions (`600`) on secrets blocks Claude entirely
- Files Claude creates are group-accessible to you

### Why This Works

| File | Permissions | Your access | Claude's access |
|------|-------------|-------------|-----------------|
| `src/main.py` | `664` (rw-rw-r--) | owner | group (rw) |
| `.env` | `600` (rw-------) | owner | none |
| `README.md` | `664` (rw-rw-r--) | owner | group (rw) |
| (claude creates) `new.py` | `664` | group (rw) | owner |

### Why Not Command Wrappers?

A functional wrapper approach (intercepting `cat`, `less`, etc.) is bypassable via:
- Symlinks and path traversal
- Glob expansion (`cat .*`)
- Subshells (`bash -c "cat .env"`)
- Other file-reading commands (`grep`, `awk`, `sed`, `sort`, etc.)

Kernel-enforced permissions have none of these weaknesses.

## Setup

### 1. Create the Claude User

Create a system user with your primary group (no home directory needed):

```bash
sudo useradd -r -s /bin/bash -g $(id -g) claude
```

Flags:
- `-r`: system account (UID in system range, no aging info)
- `-s /bin/bash`: set shell
- `-g $(id -g)`: set primary group to YOUR primary group

### 2. Create Home Directory

Claude Code needs a home directory for its config:

```bash
sudo mkhomedir_helper claude
```

Or manually:
```bash
sudo mkdir /home/claude
sudo chown claude:$(id -g -n) /home/claude
sudo chmod 750 /home/claude
```

### 3. Make Claude Binary Accessible

If Claude is installed in your home directory (e.g., `~/.local/bin/claude`), the `claude` user needs traverse permission:

```bash
chmod g+x ~/.local ~/.local/share ~/.local/share/claude ~/.local/share/claude/versions
```

(Skip this if Claude is installed system-wide in `/usr/local/bin`.)

### 4. Configure Sudoers (Passwordless)

Allow running Claude as the `claude` user without password prompts:

```bash
# Create sudoers rule (use visudo for safety)
sudo visudo -f /etc/sudoers.d/claude
```

Add this line (replace `yourusername` with your actual username):

```
yourusername ALL=(claude) NOPASSWD: ALL
```

Or use the simpler one-liner:
```bash
echo 'yourusername ALL=(claude) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/claude
```

### 5. Create Patterns Config File

Create a config file listing sensitive file patterns to protect:

```bash
mkdir -p ~/.config/restricted-claude
cat > ~/.config/restricted-claude/patterns << 'EOF'
# Sensitive files to protect from Claude
# Supports wildcards (passed to find -name)
.env
.env.*
.env.local
credentials.json
secrets.yaml
*.pem
*.key
EOF
```

### 6. Configure Claude User Environment

Set up the `claude` user's PATH and create a symlink so Claude Code can find itself:

```bash
# Add PATH to claude user's .bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' | sudo tee -a /home/claude/.bashrc

# Create symlink so Claude Code finds its binary
sudo -u claude mkdir -p /home/claude/.local/bin
sudo -u claude ln -s /home/lousydropout/.local/bin/claude /home/claude/.local/bin/claude
```

(Replace `/home/lousydropout` with your actual home directory path.)

### 7. Configure Dev Tools for Claude User

Many development tools (nvm, bun, cargo, pyenv) are installed per-user. Install them directly for the claude user to avoid permission issues.

**nvm (Node.js):**
```bash
# Install nvm for claude user
sudo -u claude bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash'

# Install LTS node
sudo -u claude bash -c 'source ~/.nvm/nvm.sh && nvm install --lts'
```

The nvm install script adds lines to the end of `.bashrc`, but they need to be moved **before** the non-interactive guard for Claude Code to use them. Edit `/home/claude/.bashrc` to move the nvm config to the top:

```bash
# Load nvm before the non-interactive guard so it works in Claude Code
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
# ... rest of .bashrc
```

**Important:** nvm reads `~/.npmrc` from both users. If your main user has `~/.npmrc`, add group read permission:
```bash
chmod g+r ~/.npmrc
```

### 8. Add Wrapper Function to .bashrc

Add this to your `~/.bashrc`:

```bash
# Claude Code isolation wrapper
# Capture the real claude binary path (which is external, unaffected by aliases)
unalias claude 2>/dev/null
_CLAUDE_BIN="$(which claude 2>/dev/null)"

restricted-claude() {
  local config="$HOME/.config/restricted-claude/patterns"

  if [[ -z "$_CLAUDE_BIN" ]]; then
    echo "Error: claude not found in PATH" >&2
    return 1
  fi

  # Pre-create .claude directory and settings file with group permissions
  # (prevents Claude Code from creating them with restrictive permissions)
  mkdir -p .claude && chmod 770 .claude
  touch .claude/settings.local.json && chmod 660 .claude/settings.local.json

  if [[ ! -f "$config" ]]; then
    echo "Warning: No patterns file at $config" >&2
    echo "Running claude without file restrictions..." >&2
  else
    while IFS= read -r pattern || [[ -n "$pattern" ]]; do
      [[ -z "$pattern" || "$pattern" == \#* ]] && continue
      find . -name "$pattern" -type f \
        -not -path '*/.git/*' \
        -not -path '*/.ssh/*' \
        -not -path '*/dist/*' \
        -not -path '*/build/*' \
        -not -path '*/node_modules/*' \
        -not -path '*/.venv/*' \
        -not -path '*/venv/*' \
        -not -path '*/.env/*' \
        -not -path '*/env/*' \
        -not -path '*/target/*' \
        -exec chmod -v 600 {} \;
    done < "$config"
  fi

  sudo -u claude bash -lc 'umask 002 && exec "$0" "$@"' "$_CLAUDE_BIN" "$@"
}

alias claude="restricted-claude"
```

The function:
- Captures the real claude binary path before the alias is defined
- Pre-creates `.claude/` directory (770) and `settings.local.json` (660) with group permissions
- Reads patterns from the config file (supports wildcards)
- Recursively finds matching files in current directory
- Excludes sensitive/build directories (`.git`, `.ssh`, `node_modules`, `venv`, `.venv`, `target`)
- Sets matching files to `600` (owner-only) with verbose output
- Runs Claude as the `claude` user with login shell (`-l`) and `umask 002`

### 9. (Optional) Set Your Umask

If your files are currently more restrictive, you may want to ensure new files you create are group-accessible:

```bash
# Add to your own .bashrc
umask 002
```

Or fix existing project files:

```bash
chmod -R g+rw ./project
find ./project -type d -exec chmod g+x {} \;
```

## Usage

### Running Claude

After setup, just run:

```bash
claude
```

The `restricted-claude` function (aliased to `claude`) will:
1. Find and protect all files matching patterns in your config
2. Show verbose output for each file it protects
3. Run Claude as the `claude` user

### Accessing Files Yourself

Nothing changes for you. You're the owner of your files and in the shared group, so you have full access to everything including files Claude created.

### Quick Reference

| Task | Command |
|------|---------|
| Run Claude (with auto-protection) | `claude` |
| Add a sensitive pattern | Edit `~/.config/restricted-claude/patterns` |
| Manually protect a file | `chmod 600 <file>` |
| Protect a directory | `chmod 700 <dir>` |
| Make file accessible to Claude | `chmod 664 <file>` (or leave defaults) |

## Verification

Test that the setup works:

```bash
# As yourself - should work
cat .env

# As claude - should fail
sudo -u claude cat .env
# Expected: cat: .env: Permission denied
```

## Security Considerations

1. **Ensure `claude` has no privilege escalation paths:**
   ```bash
   # Verify claude is not in sudo/wheel/docker groups
   groups claude
   ```

2. **Home directory:** The `claude` user has `/home/claude` for Claude Code's config. If Claude needs git/ssh access, configure those separately for that user.

3. **New secrets:** Files matching patterns in your config are automatically protected each time you run `claude`. For new patterns, add them to `~/.config/restricted-claude/patterns`.

4. **Shared group trust:** Claude can read/write anything group-accessible. This is the intended tradeoff for usability.

5. **Excluded directories:** The wrapper skips `.git`, `node_modules`, `venv`, `.venv`, and `target` for performance. Sensitive files in these directories won't be auto-protected (but they're typically not there anyway).

## Troubleshooting

### Claude can't access project files

Ensure your project files have group read/write:
```bash
chmod -R g+rw ./project
```

### You can't edit files Claude created

The wrapper sets `umask 002` inline, so files Claude creates should be group-writable (`664`). If not, check that the wrapper function is using `bash -lc 'umask 002 && exec "$0" "$@"'`.

### Claude can still read .env

Check the file permissions:
```bash
ls -la .env
# Should show: -rw------- (600)
```

If permissions look correct, ensure Claude isn't in additional groups that have access.

### "Warning: No patterns file" message

Create the config file:
```bash
mkdir -p ~/.config/restricted-claude
touch ~/.config/restricted-claude/patterns
```

Then add your patterns (one per line, wildcards supported).

### Files in excluded directories not protected

The wrapper skips `.git`, `.ssh`, `node_modules`, `venv`, `.venv`, and `target`. The `.ssh` exclusion is critical - SSH requires strict permissions on its files and will refuse to work if they're modified. If you need to protect files in other excluded directories, either:
- Manually `chmod 600` them, or
- Remove the corresponding `-not -path` line from the function

### SSH permissions broken after running claude in home directory

If you ran `claude` in your home directory and SSH stops working with "Bad owner or permissions" errors, restore SSH permissions:

```bash
chmod 700 ~/.ssh
find ~/.ssh -type f -exec chmod 600 {} \;
find ~/.ssh -type d -exec chmod 700 {} \;
chmod 644 ~/.ssh/*.pub 2>/dev/null
chmod 644 ~/.ssh/known_hosts 2>/dev/null
```

**Prevention:** Avoid running `claude` directly in your home directory. The wrapper's pattern matching could affect dotfiles. Run it in project directories instead.

### "claude command not found" or PATH warnings

Claude Code checks for its binary in the `claude` user's `~/.local/bin`. Fix with:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' | sudo tee -a /home/claude/.bashrc
sudo -u claude mkdir -p /home/claude/.local/bin
sudo -u claude ln -s $(which claude) /home/claude/.local/bin/claude
```

Ensure the wrapper uses `bash -lc` (login shell) to source `.bashrc`.

### Git "dubious ownership" errors

When Claude runs git commands in your repository, you may see:

```
fatal: detected dubious ownership in repository at '/path/to/repo'
```

This is git's security feature preventing operations in repositories owned by different users. Since Claude runs as a separate user (`claude`), it doesn't own your repositories.

**Fix:** Add your repositories as safe directories at the system level:

```bash
sudo git config --system --add safe.directory /path/to/your/repo
```

Or for all repositories (less secure but more convenient):

```bash
sudo git config --system --add safe.directory '*'
```

**Note:** Running `git config --global --add safe.directory` as yourself won't work because it modifies your user's git config, not the `claude` user's config. The `--system` flag applies the setting system-wide for all users.

### Git "Author identity unknown" errors

When Claude tries to commit, you may see:

```
Author identity unknown
*** Please tell me who you are.
```

The `claude` user needs git identity configured:

```bash
sudo -u claude git config --global user.email "your-email@example.com"
sudo -u claude git config --global user.name "Your Name"
```

This sets up git identity for the `claude` user so commits work correctly.

### `.claude/` directory or files have restrictive permissions

Claude Code creates a `.claude/` subdirectory and `settings.local.json` in your project for its internal state. By default, it creates these with restrictive permissions (owner-only), which blocks your access since Claude owns them.

**Fix:** The wrapper function now pre-creates these with group permissions before Claude runs:

```bash
mkdir -p .claude && chmod 770 .claude
touch .claude/settings.local.json && chmod 660 .claude/settings.local.json
```

If you already have these with wrong permissions:

```bash
chmod 770 .claude
chmod 660 .claude/settings.local.json
```

This is already handled in the wrapper function, so new projects will work automatically.
