# Managed Macs and TLS inspection

PocketPortal Connect supports Macs where employer software inspects TLS
traffic. The connection engine combines:

- The JVM's normal trust store, including a company CA installed for Java.
- An optional PocketPortal PEM supplied with `--ca-certificate`.

The launcher also lets device discovery fall back to curl's normal managed
trust configuration when the direct PocketPortal certificate is replaced by a
company-issued inspection certificate.

## First-run bootstrap

The initial launcher run uses SSH only to copy the server certificate and read
the bridge credential. The credential is stored in the current user's macOS
login Keychain; it is not written into the repository or shell profile.

If your company provides a certificate installation utility for Java and curl,
run it before launching Connect.

The current work-Mac validation remained connected to PocketPortal while the
corporate VPN was active. That proves this specific network and VPN
configuration works; other employers may enforce different routing, firewall,
or device-access policies.

## Trust errors

If the client reports a certificate path or trust failure:

1. Confirm the company CA is available to Java.
2. Confirm `~/.config/pocketportal/pocketportal-ca.pem` exists.
3. Rerun the company certificate installer if managed trust recently changed.
4. Restart Connect after changing any trust store.

!!! warning
    Never copy a company private key or private trust-store password onto the
    PocketPortal server. Only public CA certificates belong in client trust.
