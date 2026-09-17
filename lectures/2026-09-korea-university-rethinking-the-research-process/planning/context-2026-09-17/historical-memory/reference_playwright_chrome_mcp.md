---
name: reference-playwright-chrome-mcp
description: User-level `playwright-chrome` MCP server for Codex and Claude Code on Mac and omarchy, driving the real Chrome via the Playwright extension with a per-profile token
metadata:
  type: reference
---

Set up 2026-09-16 by the Codex peer during the Korea University lecture build.
- Server name `playwright-chrome`, registered in `~/.claude.json` and `~/.codex/config.toml` on both hosts.
- Launcher `~/.local/bin/playwright-chrome-mcp` sources `~/.config/playwright-mcp/extension.env` (0600, holds PLAYWRIGHT_MCP_EXTENSION_TOKEN) for its own process only. README beside it explains token rotation via the extension status page.
- Tokens are per browser profile: Mac token on Mac, omarchy token on omarchy. Never in repos or chat.
- Restart or reconnect the client after changing the config. Pre-existing plain `playwright` MCP entries were left in place.

Related: [[project-korea-university-talk]] (used for the deck's Chrome captures).
