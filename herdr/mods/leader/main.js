// A Helix-style "window mode": bind a leader key to `mod.open:leader`, then
// one more key acts on the focused pane. Esc (or any unknown key) cancels.

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { run, props, closeOverlay, theme } from "herdr";

const DIRS = { h: "left", j: "down", k: "up", l: "right" };

const ACTIONS = {
  v: ["pane.split", { direction: "right" }],
  s: ["pane.split", { direction: "down" }],
  q: ["pane.close", {}],
  o: ["pane.zoom", {}],
};

const HINTS = [
  ["h j k l", "focus ← ↓ ↑ →"],
  ["H J K L", "swap ← ↓ ↑ →"],
  ["v", "split right"],
  ["s", "split down"],
  ["q", "close pane"],
  ["o", "zoom"],
];

export default class Leader extends View {
  init(_props, cx) {
    this.handle = cx.focus_handle();
    this.handle.focus();
  }

  close() {
    closeOverlay(props()?.overlay);
  }

  act(e) {
    const ch = e.key_char ?? e.key;
    if (!ch || e.modifiers?.platform || e.modifiers?.control || e.modifiers?.alt) return false;
    const lower = ch.toLowerCase();
    const shifted = e.modifiers?.shift || ch !== lower;
    let cmd = null;
    if (DIRS[lower]) cmd = [shifted ? "pane.swap" : "pane.go", { direction: DIRS[lower] }];
    else if (!shifted && ACTIONS[lower]) cmd = ACTIONS[lower];
    if (!cmd) return false;
    this.close();
    run(cmd[0], cmd[1]);
    return true;
  }

  render(cx) {
    const t = theme();
    return v_flex()
      .id("leader")
      .track_focus(this.handle)
      .on_key_down((e, cx) => {
        // Ignore bare modifier presses (e.g. shift on its way to H).
        if (["shift", "control", "alt", "platform", "cmd", "function"].includes(e.key)) return;
        if (!this.act(e)) this.close();
        cx.stop_propagation();
      })
      .size_full()
      .p(16)
      .gap(6)
      .bg(t.popover)
      .text_size(13)
      .child(
        h_flex()
          .items_center()
          .pb(4)
          .child(div().flex_1().font_semibold().text_color(t.foreground).child("Pane"))
          .child(div().text_size(11).text_color(t.dim).child("Esc")),
      )
      .children(
        HINTS.map(([k, label], i) =>
          h_flex()
            .id(`hint-${i}`)
            .gap(12)
            .child(div().w(70).font_family("Berkeley Mono").text_color(t.accent).child(k))
            .child(div().text_color(t.muted).child(label)),
        ),
      );
  }
}
