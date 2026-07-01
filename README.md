# setup-atago

GitHub Action to install the [atago](https://github.com/nao1215/atago) CLI.

It downloads a prebuilt release binary instead of building from source, so your
workflows stay fast — no Go setup, no `go build`. Works on Linux, macOS, and
Windows (amd64 / arm64).

> [!WARNING]
> atago has not been released yet, so this action does not work at the moment —
> there is no binary to download. It downloads from atago's GitHub Releases, and
> the first release (`v0.1.0`) is not published. This action becomes usable once
> that release exists.

## Quick start

```yaml
- uses: nao1215/setup-atago@v1
- run: atago run ./spec
```

That's it — `atago` is now on `PATH`.

## Pin a version

```yaml
- uses: nao1215/setup-atago@v1
  with:
    version: v0.1.0 # default: latest
```

For reproducible CI, pin an exact version instead of `latest`, so a new atago
release cannot change what your workflow installs.

## Inputs

| Name                 | Default               | Description                                                      |
| -------------------- | --------------------- | ---------------------------------------------------------------- |
| `version`            | `latest`              | Release to install: `latest`, `v0.1.0`, or `0.1.0`.              |
| `github-token`       | `${{ github.token }}` | Token for API requests / downloads (avoids rate limiting).       |
| `install-dir`        | `$HOME/.atago/bin`    | Where to install the binary. Added to `PATH`.                    |
| `verify-checksum`    | `true`                | Verify the archive against `checksums.txt` (SHA-256).            |
| `verify-attestation` | `false`               | Verify build provenance with `gh attestation verify` (opt-in).   |
| `add-to-path`        | `true`                | Add the install directory to `PATH`. Set `false` for outputs only. |

## Outputs

| Name          | Description                                       |
| ------------- | ------------------------------------------------- |
| `version`     | Installed version (e.g. `v0.1.0`).                |
| `bin-path`    | Absolute path to the `atago` binary.              |
| `install-dir` | Directory the binary was installed into.          |

## Verification behavior

The action fails (rather than silently continuing) when a verification you
enabled cannot be completed:

- `verify-checksum: true` (default): the install fails if `checksums.txt` cannot
  be downloaded, if the archive is missing from it, or if the SHA-256 does not
  match. Set `verify-checksum: false` to skip the check entirely.
- `verify-attestation: true`: the install fails if the `gh` CLI is unavailable,
  if neither `GH_TOKEN` nor `GITHUB_TOKEN` is set, or if `gh attestation verify`
  fails. It is opt-in and skipped by default.

The action derives release asset names (`atago_<version>_<os>_<arch>.<ext>`)
from atago's [goreleaser](https://goreleaser.com/) config. If atago's release
naming changes, this action must be updated to match.

## License

[MIT](./LICENSE) © CHIKAMATSU Naohiro
