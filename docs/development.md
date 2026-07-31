# Development

PocketPortal Connect is a Kotlin/JVM application with a dependency-free macOS
launcher and a small JavaScript for Automation inventory parser.

## Build and test

```bash
./gradlew clean build
./gradlew installDist
./scripts/test-macos-package.sh
```

The development distribution is written to:

```text
build/install/pocketportal-connect-engine/
```

Build a versioned user-facing archive with:

```bash
./scripts/build-macos-release.sh 0.1.0
```

Release tags matching `v*` build the archive on macOS, generate a SHA-256
checksum, and publish both files to GitHub Releases.

## Boundaries

This repository owns:

- Client connection lifecycle
- Local ADB listener and discovery
- Trust composition
- macOS configuration and Keychain integration
- Terminal interaction
- Client packaging and releases

The server repository owns device inventory, bridge authorization, physical
ADB commands, TLS server configuration, and USB restoration.

Protocol changes must follow the [bridge contract](bridge-contract.md).

## Verification

Routine CI builds and tests on macOS. Physical-device verification remains an
explicit hardware test. The Pixel 4 XL path has passed from personal and
managed work Macs, including clean teardown back to its USB serial:

1. Open a client session.
2. Confirm `adb devices -l` reports the loopback device.
3. Run a harmless device query.
4. End the session with `Ctrl+C`.
5. Confirm local ADB removes the endpoint.
6. Confirm the server reports the physical USB serial again.
