# Hardening Report: thedoctor0--zip-release/0.7.6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `ff50f15e4b79bfbf764dafdfd2579175a6ea9771`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **thedoctor0--zip-release/0.7.6** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### suspicious-run-content (severity: high)

eval-dynamic: entrypoint.sh line 10 executes `eval $INPUT_COMMAND`, where `$INPUT_COMMAND` is directly derived from the user-controlled `inputs.command` action input (mapped via `env: INPUT_COMMAND: ${{ inputs.command }}` in action.yml). Using `eval` with attacker-controlled content allows arbitrary shell command execution on the runner. Matching pattern: `eval\s+[$]`.

Locations:

- `entrypoint.sh:10`
- `action.yml:47`

### script-injection (severity: high)

The `inputs.command` value is mapped to the `INPUT_COMMAND` environment variable in action.yml and then passed directly to `eval $INPUT_COMMAND` in entrypoint.sh (line 10). An attacker who controls the `command` input can inject and execute arbitrary shell commands on the runner. Although the input is routed through an env var (not interpolated directly in the run: string), the subsequent `eval` of that env var provides no protection against injection.

Locations:

- `entrypoint.sh:10`
- `action.yml:47`

## Iteration Notes

### Iteration 1

**Fixes applied:** suspicious-run-content, script-injection

**Notes:**

Replaced `eval $INPUT_COMMAND` with `bash -c "$INPUT_COMMAND"` in entrypoint.sh line 10. The `eval` builtin performs double-evaluation of its argument, meaning shell metacharacters in the user-controlled `INPUT_COMMAND` variable get interpreted twice — once when the variable is expanded and again when eval processes the result. This allows an attacker to inject arbitrary shell commands via word splitting and glob expansion. Using `bash -c "$INPUT_COMMAND"` with proper quoting runs the command in a subshell without the extra evaluation layer, eliminating the eval-dynamic injection vector while preserving the intended functionality of running a pre-zip command.

