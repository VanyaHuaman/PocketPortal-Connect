# PocketPortal bridge contract

PocketPortal Connect and the PocketPortal server release independently across
a deliberately small protocol boundary.

## Discovery

Connect reads:

```http
GET /api/devices
```

It uses the response only to display and select online devices. Additive JSON
fields are compatible. Removing or changing the meaning or type of an existing
field requires a new protocol version.

The client currently consumes:

- `serial`
- `state`
- `model`
- `manufacturer`
- `androidVersion`
- `batteryPercentage`
- `chargingState`
- `screenState`
- `formFactor`

## Device bridge

Connect opens:

```http
GET /api/devices/{serial}/adb
Upgrade: websocket
Authorization: Bearer TOKEN
```

The WebSocket carries binary ADB transport bytes only. The server validates the
serial against live inventory, enables the selected device's authenticated
network ADB transport, and restores USB mode when the bridge closes.

## Security requirements

- Non-loopback servers require `wss://`.
- The local ADB listener binds only to `127.0.0.1`.
- The bearer credential is stored in the macOS login Keychain.
- Connect combines the JVM trust store with an optional PocketPortal PEM.
- The protocol must never expose the server's shared ADB smart socket.
- Router port forwarding is not a supported deployment method.

## Compatibility

The extracted client begins at protocol generation `1`. Before either project
introduces a breaking protocol change, add an explicit version/capabilities
handshake and retain a clear unsupported-version error.
