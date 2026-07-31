# Install and connect

## Requirements

- macOS
- Java 17 or newer
- Android Studio or Android SDK Platform Tools
- Network access to a
  [configured PocketPortal server](https://vanyahuaman.github.io/PocketPortal/)
- SSH access for the one-time credential bootstrap

## Download and install

Download the current macOS ZIP archive and its SHA-256 checksum from
[PocketPortal Connect releases](https://github.com/VanyaHuaman/PocketPortal-Connect/releases).

```bash
unzip pocketportal-connect-VERSION-macos.zip
cd pocketportal-connect-VERSION-macos
./install.sh
```

The installer uses no administrator privileges. It installs the immutable
release under `~/.local/share/pocketportal-connect` and links the command at
`~/.local/bin/pocketportal-connect`. If `~/.local/bin` is not already on
`PATH`, follow the installer's printed instruction.

## First connection

```bash
pocketportal-connect connect \
  --server wss://POCKETPORTAL_HOST:8443 \
  --ssh-target USER@POCKETPORTAL_HOST
```

On its first run, the launcher:

1. Builds the client distribution if it is missing.
2. Finds ADB in the Android SDK or `PATH`.
3. Copies the PocketPortal certificate over SSH.
4. Retrieves the bridge credential and stores it in the login Keychain.
5. Saves the server settings in `~/.config/pocketportal/`.
6. Shows the live device picker.

Later runs require no arguments:

```bash
pocketportal-connect connect
```

## Verify Android Studio connectivity

Keep Connect running and check:

```bash
adb devices -l
```

The selected device appears through a loopback endpoint similar to:

```text
127.0.0.1:15556  device  model:Pixel_4_XL
```

Android Studio continues using its normal local ADB daemon and should display
the same device in Running Devices.

The first physical-device workflow was verified on a personal Mac. The same
setup was then verified on a managed work Mac while its corporate VPN was
connected.

## Disconnect safely

Press **Ctrl+C** in the Connect terminal. The client removes the loopback ADB
entry, closes the WSS session, and the server restores the physical device to
USB mode.

From a separate terminal, the packaged command can inspect or end the session:

```bash
pocketportal-connect status
pocketportal-connect disconnect
```
