# PocketPortal Connect

PocketPortal Connect makes an Android device attached to a PocketPortal server
available to the normal local ADB daemon used by Android Studio. It opens one
loopback-only ADB listener and carries only that device's ADB bytes over an
authenticated WSS connection. It does not provide SSH or arbitrary network
forwarding.

## Current support

- macOS client
- Android Studio's normal local ADB daemon
- Automatic Android SDK/ADB discovery
- Managed TLS inspection plus an optional PocketPortal PEM certificate
- macOS Keychain credential storage
- Interactive device picker with live device details
- Explicit disconnect and server-side restoration to USB mode

The PocketPortal server remains in
[`VanyaHuaman/PocketPortal`](https://github.com/VanyaHuaman/PocketPortal).

Documentation is published at
[`vanyahuaman.github.io/PocketPortal-Connect`](https://vanyahuaman.github.io/PocketPortal-Connect/).

## Install on macOS

Prerequisites:

- Java 17 or newer
- Android Studio or Android SDK Platform Tools
- Network access to the PocketPortal server
- SSH access for the one-time certificate and credential bootstrap

Download the current macOS archive and checksum from
[GitHub Releases](https://github.com/VanyaHuaman/PocketPortal-Connect/releases),
then:

```bash
unzip pocketportal-connect-VERSION-macos.zip
cd pocketportal-connect-VERSION-macos
./install.sh

pocketportal-connect connect \
  --server wss://192.168.0.151:8443 \
  --ssh-target vanya@192.168.0.151
```

The user-local installer places immutable release files under
`~/.local/share/pocketportal-connect` and links the command into
`~/.local/bin`. It never requires `sudo`.

Connect discovers ADB, installs the server certificate, stores the bridge
credential in the login Keychain, remembers the server, and presents the
device picker. Later runs need only:

```bash
pocketportal-connect connect
```

Press `Ctrl+C` to disconnect the local ADB transport and restore the device to
USB mode on the PocketPortal server.

Inspect or end the current session from another terminal:

```bash
pocketportal-connect status
pocketportal-connect disconnect
```

## Build and test

```bash
./gradlew test
./gradlew installDist
```

The installed development executable is:

```text
build/install/pocketportal-connect-engine/bin/pocketportal-connect-engine
```

## Direct CLI

The launcher is recommended. The engine can also be invoked directly:

```bash
export POCKETPORTAL_CONNECT_TOKEN='token-with-at-least-32-characters'

./build/install/pocketportal-connect-engine/bin/pocketportal-connect-engine \
  --server wss://POCKETPORTAL_HOST:8443 \
  --serial DEVICE_SERIAL \
  --adb /path/to/adb \
  --ca-certificate /path/to/pocketportal-ca.pem
```

See [the bridge contract](docs/bridge-contract.md) for the security and
compatibility boundary.

## Project boundaries

This repository owns client-side connection lifecycle, ADB discovery, local
configuration, Keychain integration, terminal interaction, and future client
packaging. The PocketPortal repository owns device inventory, authorization,
TLS server setup, the server-side bridge, and physical-device restoration.
