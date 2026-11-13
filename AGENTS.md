# AGENTS.md

`trash` is a small Swift CLI that moves files/folders to the macOS Trash
asynchronously (via `NSWorkspace.recycle`).

- `Sources/Trash/Trash.swift` — the entire app. `Trash.put` awaits the async
  `NSWorkspace.recycle`. The `nonisolated(unsafe)` on `CLI.standardError` is
  safe, not dead code: it's assigned once at startup and only touched from
  `CLI.main()`'s single thread. Don't remove it — Swift 6 strict concurrency
  checking will fail to compile without it.
- `Tests/TrashTests/TrashTests.swift` — XCTest suite. Tests move real files from
  `NSTemporaryDirectory()` into the actual Trash; no network, no fixtures.
- `.github/workflows/ci.yml` — test (swiftlint + `swift test`) → build (both arches
  + goreleaser): snapshot on branches, real release on `v*` tags.
- `.github/renovate.json` — Renovate: pins Actions to digests (7-day cooldown,
  `actions/*` automerge) and bumps `.swift-version` from `swiftlang/swift` releases.

## CLI behavior

No args, `-h`/`--help` print usage, exit 0. `-v`/`--version` print the `version`
constant, exit 0. Otherwise every arg is a path to trash. Errors go to stderr, exit 1.

## Constraints

Zero package dependencies — keep `Package.swift` dependency-free.

## Build / test / run

```sh
swift build
swift test -v
swift run trash <paths>
swiftlint             # same rules CI runs; no config file
actionlint            # run after changing anything under .github/workflows
```

Requires the Swift toolchain pinned in `.swift-version` (`Package.swift` uses tools-version 6.4).

## Release builds

arm64 and x86_64 builds use separate `--scratch-path`s (`.build-arm64`, `.build-x86_64`)
on purpose, to avoid a race between the two builds. Don't merge them.

## Releasing

`Trash.swift`'s hardcoded `version` constant must be bumped to match the new
tag *before* tagging (see e.g. commit "Cut 0.3.7"). Nothing enforces this;
`trash --version` just prints the constant.

## hack.go / goreleaser gotcha

`hack.go` is an empty Go `main` stub, not application code — never edit it.
goreleaser only builds Go projects, so it just gives `main:` something to
point at; `.goreleaser.yml`'s `pre`/`post` hooks build the binary via
`swift build -c release` and copy it into `dist/`. To change the build, edit
`.goreleaser.yml` or `Package.swift`, not `hack.go`.
