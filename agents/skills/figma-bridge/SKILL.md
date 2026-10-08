---
name: figma-bridge
description: Read Figma files (layers, auto-layout, Dev Mode CSS, text styles, variables, PNG/SVG exports) through a local plugin bridge, with no API rate limit. Use whenever a task needs values from a Figma design or a figma.com link comes up. Prefer it over the Figma REST API and the Figma MCP, which are rate limited for Tim's account.
---

# Figma Bridge

A development plugin (`plugin/`) runs in Figma desktop and long-polls a relay on `localhost:7865`. `bridge.mjs` sends commands through that relay. It reads whatever file Tim has open, with no quota.

```
CLI ──POST /cmd──▶ relay (localhost:7865) ◀──GET /next── plugin UI ──▶ plugin main (figma.*)
```

## Connect

1. Check for a running relay: `curl -s -o /dev/null -w '%{http_code}' localhost:7865/`. `404` means it is up; `000` means it is down.
2. If it is down, start `node ~/.dotfiles/agents/skills/figma-bridge/bridge.mjs serve` as a background process. One relay serves every session, so `EADDRINUSE` means another session already runs it.
3. Run `node ~/.dotfiles/agents/skills/figma-bridge/bridge.mjs info`. "Plugin not connected" means you ask Tim to open the file in Figma desktop and run Plugins → Development → Figma Bridge. Check that `info.file` is the file you expect: the plugin reads whichever file it was started in.

One-time setup on a new machine: Figma desktop → Plugins → Development → Import plugin from manifest… → `~/.dotfiles/agents/skills/figma-bridge/plugin/manifest.json`. Development plugins run only in the desktop app.

## Commands

```sh
B=~/.dotfiles/agents/skills/figma-bridge/bridge.mjs
node $B info                                   # pages and selection
node $B find "header" --type COMPONENT_SET     # search layer names on every page
node $B tree <node> --depth 2 > tree.json      # layer tree; no --depth means everything
node $B css <node> --deep > css.json           # Dev Mode CSS per layer
node $B export <node> --scale 2 --out x.png    # also --format svg|jpg|pdf
node $B variables                              # variable collections with values per mode
node $B styles                                 # paint, text, effect and grid styles
node $B eval 'return figma.currentPage.selection.map(n => n.name)'
```

`<node>` takes `244:12185`, `244-12185` or a full figma.com URL with `node-id`. Without a node, `tree` and `css` use Tim's current selection, so "look at what I selected" works.

## Working with the output

- A full page tree is large (835 layers is 1.6 MB). Write it to a scratch file and query it with `jq` or `node -e`; do not read it whole. Start with `--depth 1` or `2` to find the frame you need.
- `tree` drops default values. Colours are 0–1 RGB. Style and variable references appear by name (`"textStyleId": "Heading H1"`, `{"variable": "…"}`).
- Figma sizes are often fractional (`11.333`). Round them to whole pixels in code.
- `eval` runs an async function body with the full Plugin API as `figma`. Use it for anything the fixed commands miss.
- Figma reloads the plugin itself when `plugin/code.js` changes. If you edit it, wait a few seconds and rerun the command.
