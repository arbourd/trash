# AGENTS.md

`trash` is a small Swift CLI that moves files/folders to the macOS Trash
asynchronously (via `NSWorkspace.recycle`).

- `Sources/Trash/Trash.swift` — the whole app. Keep `nonisolated(unsafe)` on
  `CLI.standardError`: it's assigned once at startup and only touched from
  `CLI.main()`'s single thread, and Swift 6 strict concurrency won't compile without it.
- `Tests/TrashTests/TrashTests.swift` — tests move real files into the actual Trash.
- `skills/trash/SKILL.md` — agent skill documenting CLI behavior (args, flags, exit
  codes). Update it when that behavior changes.

## Constraints

Zero package dependencies — keep `Package.swift` dependency-free.

## Checks

```sh
swiftlint             # same rules CI runs; no config file
actionlint            # run after changing anything under .github/workflows
bunx --package renovate renovate-config-validator --strict  # run after changing .github/renovate.json
```

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
