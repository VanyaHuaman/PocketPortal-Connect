# Troubleshooting

## ADB was not found

Open Android Studio once and install **Android SDK Platform Tools**. Connect
checks `ANDROID_SDK_ROOT`, `ANDROID_HOME`, the standard macOS SDK directory,
Android Studio, and `PATH`.

An explicit path is also supported:

```bash
./scripts/connect-macos.sh \
  --adb "$HOME/Library/Android/sdk/platform-tools/adb"
```

## The dashboard works but Connect inventory fails

Connect uses HTTPS for inventory and WSS for the bridge. Confirm the configured
URL includes the TLS port:

```text
wss://POCKETPORTAL_HOST:8443
```

Then check whether a managed TLS inspection certificate is trusted by both
curl and Java.

If a VPN is active, verify that it still routes the PocketPortal private-LAN
address. The validated work-Mac setup does, but VPN policies differ.

## Android Studio does not show the device

While Connect remains open:

```bash
adb devices -l
```

If the loopback device is present, reopen Android Studio's Running Devices
window. If it is `unauthorized`, approve the local Mac's ADB key on the
physical device.

## A previous session is stuck

```bash
adb disconnect 127.0.0.1:15556
```

Then confirm PocketPortal shows the physical USB serial online and relaunch
Connect.

## Reset saved client setup

Server settings and the public certificate live under:

```text
~/.config/pocketportal/
```

The bridge credential is stored in the macOS login Keychain under service:

```text
dev.pocketportal.connect
```
