# AGENTS.md

`trash` is a Swift CLI that moves files and folders to the macOS Trash asynchronously through `NSWorkspace.recycle`. Its implementation is in `Sources/Trash/Trash.swift`.

## Commands

```sh
swiftlint             # no config file
actionlint            # lint .github/workflows; run after changing anything there
bunx --package renovate renovate-config-validator --strict  # run after changing .github/renovate.json
```

Tests in `Tests/TrashTests/TrashTests.swift` move files into the actual macOS Trash. Run them only after confirming their fixtures are disposable.

When args, flags, or exit codes change, update `skills/trash/SKILL.md`.

## Hard constraints

**Dependencies:** Keep `Package.swift` dependency-free.

**Concurrency:** Preserve `nonisolated(unsafe)` on `CLI.standardError`. It is assigned once at startup and only accessed from `CLI.main()`'s single thread; Swift 6 strict concurrency requires the annotation.

**Release builds:** Keep separate scratch paths for the arm64 and x86_64 builds (`.build-arm64` and `.build-x86_64`) to prevent build races.

**Releasing:** Before tagging a release, set the hardcoded `version` constant in `Trash.swift` to match the tag. `trash --version` prints this constant; no automation checks it.

**Build config:** The Swift build runs through `.goreleaser.yml` hooks. Keep `hack.go` as the empty Go stub GoReleaser needs for its `main:` field; make build changes in `.goreleaser.yml` or `Package.swift`.
