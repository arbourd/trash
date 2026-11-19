# AGENTS.md

`trash` is a small Swift CLI, invoked as `trash`, that moves files/folders to the macOS Trash asynchronously (via `NSWorkspace.recycle`). The whole app lives in `Sources/Trash/Trash.swift`.

## Commands

```sh
swiftlint             # no config file
actionlint            # lint .github/workflows; run after changing anything there
bunx --package renovate renovate-config-validator --strict  # run after changing .github/renovate.json
```

`trash` moves real files into the actual Trash, so try it only on disposable files.

When args, flags, or exit codes change, update `skills/trash/SKILL.md`.

## Hard constraints

**Dependencies:** zero package dependencies; keep `Package.swift` dependency-free.

**Concurrency:** keep `nonisolated(unsafe)` on `CLI.standardError`. It is assigned once at startup and only touched from `CLI.main()`'s single thread, and Swift 6 strict concurrency won't compile without it.

**Release builds:** give the arm64 and x86_64 builds separate `--scratch-path`s (`.build-arm64`, `.build-x86_64`) on purpose, to avoid a race between the two builds.

**Releasing:** bump `Trash.swift`'s hardcoded `version` constant to match the new tag *before* tagging (see e.g. commit "Cut 0.3.7"). Nothing enforces this; `trash --version` just prints the constant.

**Build config:** `hack.go` is an empty Go stub that only gives goreleaser a `main:` to point at (it builds only Go projects); leave it untouched. The real build is Swift, driven by `.goreleaser.yml` hooks, so change the build in `.goreleaser.yml` or `Package.swift`.

## Testing

- Tests in `Tests/TrashTests/TrashTests.swift` move real files into the actual Trash.
