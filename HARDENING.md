<!-- markdownlint-disable -->

# Hardening Report: thedoctor0--zip-release/0.7.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **thedoctor0--zip-release/0.7.1** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: entrypoint.sh uses multiple INPUT_* environment variables (sourced from inputs.* via action.yml's env: block) in unquoted shell expansions throughout the script. Unquoted expansions allow shell metacharacters (`;`, `|`, `&`, `$(...)`, whitespace, glob chars) in attacker-controlled input values to be interpreted by the shell, enabling command injection. Affected unquoted usages include: `cd $INPUT_DIRECTORY` (line 9), `7z a -tzip $INPUT_FILENAME $INPUT_PATH $INPUT_CUSTOM` (line 19), `zip -r $INPUT_FILENAME $INPUT_PATH $INPUT_CUSTOM` (line 36), `zip -r $INPUT_FILENAME $INPUT_PATH -x $INPUT_EXCLUSIONS $INPUT_CUSTOM` (line 40), `tar -zcvf $INPUT_FILENAME $INPUT_PATH $INPUT_CUSTOM` (line 50), and loop variables built from `$INPUT_EXCLUSIONS` and `$INPUT_RECURSIVE_EXCLUSIONS`. All of these should use double-quoted expansions (e.g. `"$INPUT_FILENAME"`, `"$INPUT_PATH"`, `"$INPUT_CUSTOM"`, `"$INPUT_DIRECTORY"`).

Locations:

- `entrypoint.sh:9`
- `entrypoint.sh:14`
- `entrypoint.sh:19`
- `entrypoint.sh:30`
- `entrypoint.sh:36`
- `entrypoint.sh:40`
- `entrypoint.sh:50`
- `entrypoint.sh:56`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed all unquoted shell expansions in entrypoint.sh:
1. Quoted `$INPUT_DIRECTORY` in `cd` command.
2. Replaced unquoted `$INPUT_EXCLUSIONS`, `$INPUT_RECURSIVE_EXCLUSIONS`, and `$INPUT_CUSTOM` with bash arrays populated via `IFS=' ' read -ra ARRAY <<< "$VAR"` — splits on whitespace only, no metacharacter interpretation.
3. Quoted all `$INPUT_FILENAME` and `$INPUT_PATH` usages with double quotes.
4. Replaced string-concatenation EXCLUSIONS variable with a proper bash array `EXCLUSIONS=()` using `EXCLUSIONS+=("...")` to safely build per-element flags like `-x!value` and `--exclude=value`.
5. All for-loops now iterate over quoted array expansions `"${ARRAY[@]}"` instead of unquoted scalar variables.
6. All command invocations use `"${ARRAY[@]}"` for multi-value arguments to preserve element boundaries.

