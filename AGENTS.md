# AGENTS.md

`trash` is a small Swift CLI that moves files/folders to the macOS Trash
asynchronously (via `NSWorkspace.recycle`).

- `Sources/Trash/Trash.swift` — the entire app. `Trash.put` spins
  `CFRunLoopRun()`/`CFRunLoopStop` to block on `NSWorkspace.recycle`'s
  async-only completion handler — don't "simplify" this into an early return.
- `Tests/TrashTests/TrashTests.swift` — XCTest suite.

## Build / test / run

```sh
swift build
swift test -v
swift run trash <paths>
swiftlint             # same rules CI runs; no config file
```

CI also runs `swiftlint` (default rules, no config file) before tests.

## Releasing

`Trash.swift`'s hardcoded `version` constant must be bumped to match the new
tag *before* tagging (see e.g. commit "Cut 0.3.7"). The Homebrew formula test
in `.goreleaser.yml` asserts `trash --version` matches the tag, so a missed
bump fails the release even though the build succeeds.

## hack.go / goreleaser gotcha

`hack.go` is a one-line stub, not real application code — never edit it.
goreleaser only builds Go projects, so `hack.go` just gives it a Go main
package to point at; `.goreleaser.yml`'s `pre`/`post` hooks actually build
the binary via `swift build -c release`. To change the build, edit
`.goreleaser.yml` or `Package.swift`, not `hack.go`.
