# Your device lab, inside Android Studio.

PocketPortal Connect securely makes a physical Android device attached to your
PocketPortal server available to Android Studio's normal local ADB daemon.

[Install and connect](getting-started/installation.md){ .md-button .md-button--primary }
[PocketPortal server docs](https://vanyahuaman.github.io/PocketPortal/){ .md-button }
[View the source](https://github.com/VanyaHuaman/PocketPortal-Connect){ .md-button }

## One focused client

Connect keeps the server and desktop responsibilities separate:

| Connect owns | PocketPortal owns |
| --- | --- |
| Local loopback ADB listener | Physical USB devices |
| macOS Keychain credential | Device validation |
| Android SDK discovery | Authenticated bridge endpoint |
| Terminal device picker | USB restoration |
| Client installation and updates | Server TLS and deployment |

The client forwards binary ADB transport bytes for one selected device over an
authenticated WSS session. It does not expose a Linux shell, the server's
shared ADB daemon, or arbitrary network forwarding.

## Daily workflow

The current source-based launcher is the supported macOS entry point. After
one-time setup:

```bash
./scripts/connect-macos.sh
```

Choose a device with the arrow keys, press **Enter**, and keep the terminal
open while Android Studio uses the device. Press **Ctrl+C** to disconnect and
return the device to USB mode on the server.

!!! note
    The bridge has been validated from personal and managed work Macs,
    including a work Mac connected to its corporate VPN. A packaged macOS
    release is the next client milestone. Windows packaging and a lightweight
    native interface remain future client work.
