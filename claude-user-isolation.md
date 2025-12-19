# Claude Code: Protecting Sensitive Files

## Problem

When running Claude Code, you may want to:
- Automatically protect sensitive files (`.env`, credentials, secrets) before each session
- Have a consistent workflow that doesn't require manual permission changes

## Approach

Use a wrapper function that automatically sets restrictive permissions on sensitive files before launching Claude.

**Note:** This approach marks files as sensitive but does not provide kernel-enforced isolation since Claude runs as your user. For true isolation, you would need to run Claude as a separate user. This wrapper is useful for:
- Signaling to Claude's built-in file tools which files to avoid
- Combining with Claude's native permission deny rules
- Defense in depth alongside `.claude/settings.local.json` restrictions

## Setup

### 1. Create Patterns Config File

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

### 2. Add Wrapper Function to .bashrc

Add this to your `~/.bashrc`:

```bash
# Claude Code file protection wrapper
restricted-claude() {
  local config="$HOME/.config/restricted-claude/patterns"
  local claude_bin

  claude_bin="$(which claude 2>/dev/null)"
  if [[ -z "$claude_bin" ]]; then
    echo "Error: claude not found in PATH" >&2
    return 1
  fi

  if [[ ! -f "$config" ]]; then
    echo "Warning: No patterns file at $config" >&2
  else
    echo "Protecting sensitive files..."
    while IFS= read -r pattern || [[ -n "$pattern" ]]; do
      [[ -z "$pattern" || "$pattern" == \#* ]] && continue
      find . -name "$pattern" -type f \
        -not -path '*/.git/*' \
        -not -path '*/.ssh/*' \
        -not -path '*/node_modules/*' \
        -not -path '*/.venv/*' \
        -not -path '*/venv/*' \
        -not -path '*/target/*' \
        -exec chmod -v 600 {} \;
    done < "$config"
  fi

  "$claude_bin" "$@"
}

alias claude="restricted-claude"
```

The function:
- Reads patterns from the config file (supports wildcards)
- Recursively finds matching files in current directory
- Excludes common directories (`.git`, `.ssh`, `node_modules`, `venv`, `.venv`, `target`)
- Sets matching files to `600` (owner-only) with verbose output
- Runs Claude normally

## Usage

### Running Claude

After setup, just run:

```bash
claude
```

The `restricted-claude` function (aliased to `claude`) will:
1. Find and protect all files matching patterns in your config
2. Show verbose output for each file it protects
3. Run Claude

### Quick Reference

| Task | Command |
|------|---------|
| Run Claude (with auto-protection) | `claude` |
| Add a sensitive pattern | Edit `~/.config/restricted-claude/patterns` |
| Manually protect a file | `chmod 600 <file>` |
| Restore file to normal | `chmod 644 <file>` |

## Optional: Claude's Native Permission Deny Rules

For additional protection, you can configure Claude's built-in permission system. Add to `.claude/settings.local.json` in your project:

```json
{
  "permissions": {
    "deny": [
      "Read(.env*)",
      "Read(*.pem)",
      "Read(*.key)",
      "Read(credentials.json)",
      "Read(secrets.yaml)"
    ]
  }
}
```

This tells Claude's internal file tools to refuse reading these patterns.

## Notes

1. **No kernel enforcement:** Since Claude runs as your user, the `chmod 600` doesn't actually block Claude's access. This wrapper is primarily useful when combined with Claude's native deny rules.

2. **New secrets:** Files matching patterns in your config are automatically marked each time you run `claude`. For new patterns, add them to `~/.config/restricted-claude/patterns`.

3. **Excluded directories:** The wrapper skips `.git`, `.ssh`, `node_modules`, `venv`, `.venv`, and `target` for performance.

## Troubleshooting

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
