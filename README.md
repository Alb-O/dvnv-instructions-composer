# Codex Instructions Builder

`devenv` module for merging developer instruction fragments across imported repos.

* Upstream repos append to `developerInstructions.fragments`.
* Downstream repos import the same module and continue appending.
* Final consumer sets `developerInstructions.materializeToCodexConfig = true`.
