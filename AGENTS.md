# AGENTS.md

`trash` is a small Swift CLI that moves files/folders to the macOS Trash
asynchronously (via `NSWorkspace.recycle`).

- `Sources/Trash/Trash.swift` — the entire app. `Trash.put` spins
  `CFRunLoopRun()`/`CFRunLoopStop` to block on `NSWorkspace.recycle`'s
  async-only completion handler — don't "simplify" this into an early return.
  The `nonisolated(unsafe)` on `Trash.put`'s local `error` and on
  `CLI.standardError` is safe, not dead code: `error` is only ever written
  from inside the completion handler and only ever read after
  `CFRunLoopRun()` returns, which the run loop guarantees happens after
  that write; `standardError` is assigned once at startup and only ever
  touched from `CLI.main()`'s single thread. Don't remove either
  annotation — Swift 6 strict concurrency checking will fail to compile
  without them.
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
