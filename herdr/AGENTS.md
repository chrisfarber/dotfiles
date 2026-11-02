# Herdr config

**Before changing anything here, read Herdr's own docs.** They're the source of
truth and change with each app version:

- `~/.config/herdr-app/AGENTS.md`: the whole interface, including files,
  layouts, keys, themes, mods and commands. Herdr rewrites it on every start,
  so it matches the installed version.
- `~/.config/herdr-app/herdr.d.ts` and `gpui-kit.d.ts`: the APIs mods can use.
- `herdr-app commands`: every app command and its arguments.

Don't work from memory or from this note's summary. Herdr changes fast.

## What's here

These files are symlinked into `~/.config/herdr-app/` by `install.sh`. Herdr
writes through the links, so changes made in the app show up as diffs here.

| File | Purpose |
|---|---|
| `settings.json` | font, theme (Monokai Pro light/dark), zoom, sounds |
| `keys.json` | all key bindings |
| `themes/monokai-pro*.json` | Monokai Pro, dark from Ghostty's bundled theme, light from `../helix/monokai_pro_light.toml` |
| `mods/leader/` | `cmd-k` pane popup: h/j/k/l focus, H/J/K/L swap, v/s split, q close, o zoom (cmd may stay held: `cmd-k cmd-h`) |

Everything else in `~/.config/herdr-app/` is Herdr's or machine state. Don't
add it here.

## Things to know

- Add new files to `install.sh` too, or they won't be linked on other machines.
- A theme picked in Herdr's UI is saved per layout and overrides
  `settings.json`. To set it, run `herdr-app do app.theme --name <theme>` once
  per light/dark half. Don't edit `layouts/.state/`.
- Herdr writes `jsconfig.json` and `*.d.ts` into mod folders. They're
  gitignored.
- After any edit, check `herdr-app status` for errors. For a mod, run
  `herdr-app check ~/.config/herdr-app/mods/<name>`.
- Shipped layouts and mods are read-only. Clone them (`layout.clone`,
  `mod.clone`) before changing them.

## The user's preferences

- Dvorak keyboard. hjkl is only tolerable, and fine as a second key after a
  leader. Doesn't want arrow-key shortcuts at all.
- Wants clean, supported setups, not workarounds. A `cmd-1…9` pane-focus
  version that used self-closing invisible popups was rejected and removed.
  If Herdr adds `pane.next` or focus-by-index, suggest switching to it.
- Muscle memory comes from Ghostty and Zed; when they disagree, follow Zed.
- Current navigation: `cmd-shift-[ ]` and `ctrl-tab` tabs, `ctrl-1…9` tabs
  (Zed), `cmd-1…9` spaces (Zed uses it for panes, which Herdr can't select
  by index), `cmd-k` then a key for panes, `cmd-alt-[ ]` agents. No
  next/prev space key yet. `cmd-[ ]` is left free for `pane.next`/`pane.prev`
  (Ghostty's split prev/next) if Herdr adds them.
- Closing follows Ghostty: `cmd-w` pane, `cmd-alt-w` tab, `cmd-shift-w` space.
