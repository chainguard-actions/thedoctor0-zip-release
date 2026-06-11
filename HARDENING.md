<!-- markdownlint-disable -->

# Hardening Report: thedoctor0--zip-release/0.7.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **thedoctor0--zip-release/0.7.3** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: In entrypoint.sh, multiple env vars sourced from user-controlled inputs are used unquoted in shell commands, allowing shell metacharacter injection. Specifically:
- `$INPUT_CUSTOM` is appended unquoted to `7z a`, `zip -r`, and `tar -zcvf` commands on multiple lines (e.g. `7z a -tzip "$INPUT_FILENAME" "$INPUT_PATH" $INPUT_CUSTOM`, `zip -r "$INPUT_FILENAME" "$INPUT_PATH" $INPUT_CUSTOM`, `tar -zcvf "$INPUT_FILENAME" "$INPUT_PATH" $INPUT_CUSTOM`).
- `$INPUT_EXCLUSIONS` is iterated unquoted in `for EXCLUSION in $INPUT_EXCLUSIONS` loops, allowing word-splitting and glob expansion of attacker-controlled input.
- `$INPUT_RECURSIVE_EXCLUSIONS` is similarly iterated unquoted.
- `$INPUT_PATH` is used unquoted in several archive commands.
All these variables are set from `inputs.*` in action.yml and are therefore fully attacker-controlled. An attacker can inject shell metacharacters (`;`, `|`, `&`, `$(...)`, etc.) via these inputs to execute arbitrary commands on the runner.

Locations:

- `entrypoint.sh:19`
- `entrypoint.sh:22`
- `entrypoint.sh:30`
- `entrypoint.sh:35`
- `entrypoint.sh:40`
- `entrypoint.sh:44`
- `entrypoint.sh:55`
- `entrypoint.sh:60`
- `entrypoint.sh:68`
- `entrypoint.sh:73`
- `entrypoint.sh:80`
- `entrypoint.sh:85`
- `entrypoint.sh:91`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed all script injection vulnerabilities in entrypoint.sh by converting unquoted variable expansions to properly quoted bash arrays:
1. $INPUT_CUSTOM → CUSTOM_ARGS array, expanded as "${CUSTOM_ARGS[@]}" in all archive commands (7z, zip, tar)
2. $INPUT_EXCLUSIONS → EXCLUSION_LIST array, iterated as "${EXCLUSION_LIST[@]}" in for loops
3. $INPUT_RECURSIVE_EXCLUSIONS → RECURSIVE_EXCLUSION_LIST array, iterated as "${RECURSIVE_EXCLUSION_LIST[@]}" in for loops
4. Built EXCLUSIONS arrays using bash array syntax (EXCLUSIONS+=(...)) instead of string concatenation, expanded as "${EXCLUSIONS[@]}"
5. Added empty-string guards before splitting inputs to avoid single-empty-element arrays
6. All $INPUT_PATH references are now properly double-quoted

