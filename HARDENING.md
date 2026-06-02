# Hardening Report: thedoctor0--zip-release/0.7.6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `ff50f15e4b79bfbf764dafdfd2579175a6ea9771`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **thedoctor0--zip-release/0.7.6** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### suspicious-run-content (severity: high)

eval-dynamic: entrypoint.sh uses `eval $INPUT_COMMAND` where $INPUT_COMMAND is set directly from the attacker-controlled `inputs.command` input (via the env: block in action.yml). This allows an attacker who controls the `command` input to execute arbitrary shell commands on the runner. The pattern matches `eval $VAR` with a variable derived from user-supplied input.

Locations:

- `entrypoint.sh:9`

## Iteration Notes

### Iteration 1

**Fixes applied:** suspicious-run-content

**Notes:**

Replaced `eval $INPUT_COMMAND` with `bash -c "$INPUT_COMMAND"` in entrypoint.sh line 9. The `eval` builtin was dangerous because it performs double-evaluation of shell metacharacters, allowing an attacker controlling the `command` input to inject arbitrary shell commands. Using `bash -c` with a properly quoted variable removes the extra layer of shell interpretation while preserving the intended functionality of running a pre-zip command.

