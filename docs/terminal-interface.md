# Terminal interface

The interactive launcher shows every online Android device returned by the
PocketPortal inventory API.

```text
┌─ POCKETPORTAL CONNECT ──────────────────────────────────┐
│  Server  https://pocketportal:8443          ● online    │
├──────────────────────────────────────────────────────────┤
│  › Pixel 4 XL                               ● ONLINE    │
│    Google · Android 13 · phone                          │
│    Battery 100% · full · screen on                      │
│                                                          │
│    TB336FU                                  ● ONLINE    │
│    LENOVO · Android 16 · tablet                         │
│    Battery 25% · charging · screen on                   │
├──────────────────────────────────────────────────────────┤
│  ↑/↓ select   Enter connect   R refresh   Q quit        │
└──────────────────────────────────────────────────────────┘
```

## Controls

| Key | Action |
| --- | --- |
| `↑` / `↓` | Change the selected device |
| `Enter` | Open the selected device bridge |
| `R` | Refresh live inventory |
| `Q` | Quit without connecting |
| `Ctrl+C` | Disconnect an active session |

## Direct selection

A readable normalized model name can bypass the picker:

```bash
pocketportal-connect connect --device pixel-4-xl
```

The hardware serial remains the internal stable identifier. Advanced users can
still pass it explicitly with `--serial`.
