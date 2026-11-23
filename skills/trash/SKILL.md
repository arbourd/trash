---
name: trash
description: Move local files or directories to the macOS Trash with `trash` when asked to remove them.
---

# trash

Use `trash <paths...>` to move files or directories to the macOS Trash:

```sh
trash old.log build/ notes.txt
```

With no arguments, `trash` prints usage and exits 0. Only the first argument is checked for `-h`/`--help` or `-v`/`--version`; either option ignores later arguments.

All other arguments are paths. Quote paths with spaces. For a leading-dash path in first position, prefix it with `./`, as in `trash ./-draft.txt report.txt`.

Exit 0 means the operation succeeded. On error, `trash` prints the localized error to stderr and exits 1.
