<!-- markdownlint-disable -->

# Hardening Report: thedoctor0--zip-release/0.7.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **thedoctor0--zip-release/0.7.2** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: Multiple env vars holding workflow-controlled input values are expanded unquoted in shell commands inside entrypoint.sh. The variables $INPUT_CUSTOM (from inputs.custom), $INPUT_EXCLUSIONS (from inputs.exclusions), and $INPUT_RECURSIVE_EXCLUSIONS (from inputs.recursive_exclusions) are set via the action.yml env: block from caller-supplied inputs, but are used without double-quotes in the shell script. An attacker-controlled input value containing shell metacharacters (semicolon, pipe, ampersand, $(...), backticks) can break out of the intended command and execute arbitrary code. Affected: line 19 unquoted $INPUT_CUSTOM in 7z command; line 23 unquoted $INPUT_EXCLUSIONS in for-loop; line 29 unquoted $INPUT_RECURSIVE_EXCLUSIONS in for-loop; line 35 unquoted $EXCLUSIONS and $INPUT_CUSTOM in 7z command; line 40 unquoted $INPUT_CUSTOM in zip command; line 42 unquoted $INPUT_EXCLUSIONS and $INPUT_CUSTOM in zip command; line 48 unquoted $INPUT_CUSTOM in tar command; line 54 unquoted $INPUT_EXCLUSIONS in for-loop; line 60 unquoted $EXCLUSIONS and $INPUT_CUSTOM in tar command.

Locations:

- `entrypoint.sh:19`
- `entrypoint.sh:23`
- `entrypoint.sh:29`
- `entrypoint.sh:35`
- `entrypoint.sh:40`
- `entrypoint.sh:42`
- `entrypoint.sh:48`
- `entrypoint.sh:54`
- `entrypoint.sh:60`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed all unquoted variable expansions in entrypoint.sh that could allow shell metacharacter injection. The variables $INPUT_CUSTOM, $INPUT_EXCLUSIONS, and $INPUT_RECURSIVE_EXCLUSIONS were previously expanded unquoted in shell commands, allowing attacker-controlled values to inject shell metacharacters. The fix uses `read -ra ARRAY_NAME <<< "$VAR"` to safely split each space-separated input into a bash array, then uses `"${ARRAY[@]}"` syntax throughout the script to expand them with proper quoting. This prevents injection while preserving the intended word-splitting behavior for space-separated lists. The EXCLUSIONS string variable was also converted to an array (EXCLUSIONS=()) with elements added via `EXCLUSIONS+=("flag$EXCLUSION")` to ensure each exclusion flag is properly quoted as a single argument.

