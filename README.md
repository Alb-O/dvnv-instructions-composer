# Materializer

`devenv` module for materializing files and combining instruction text across repos.

## Options (`materializer.*` namespace)

- `projectName` (default `null`: basename of `config.devenv.root`)
- `ownFragments`
- `mergedFragments`
- `materializePath` (default `AGENTS.override.md`)
- `materializeTemplate` (`plainText` or `codexConfigToml`)

## Shared Instructions (`instructions.*` namespace)

- `instructions.fragments` (list of strings, default `[]`)

`materializer` prepends `instructions.fragments` into
`materializer.mergedFragments` with `mkBefore`, so producer modules can add
shared instruction text without writing to `materializer.*` directly.

## Output

- `outputs.materialized_text` (only when the effective merged fragment list is non-empty)

## Notes

- The `codexConfigToml` value for the `materializeTemplate` option uses codex's `developer_instructions` config key, materializing `.codex/config.toml` instead of `AGENTS.override.md`.
- Ordering strategy:
  - start with `materializer.mergedFragments` in declared order
  - append `materializer.ownFragments.<current-project>` where current project is `materializer.projectName` or the basename of `config.devenv.root`
  - de-duplicate by fragment text with keep-last semantics (so the current project fragment ends up last/highest priority)
- The main materialized instruction file is only created when this effective merged fragment list is non-empty.
