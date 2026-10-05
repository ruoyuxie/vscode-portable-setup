# Setup scope

- Read README.md before installing.
- This setup is for a local macOS VS Code client and a separate remote machine.
- Determine which machine you can actually access. Install shell aliases there.
- Install macOS keybindings only on the local Mac, in the active VS Code user/profile directory.
- If you can access only the remote host, complete the remote installation and provide the exact local Mac command for the remaining step.
- Use install.sh. Existing configurations must be backed up before modification.
- Preserve unrelated shell configuration and SSH/cluster/project settings.
- Do not recreate original-machine paths or copy secrets/environment variables.
- Do not execute gpush, Slurm cancellation helpers, tx, or any other alias just to test installation.
- Do not install optional tools or extensions automatically; report which are needed for the commands the user intends to use.
- The bundled keybindings.json is a saved 2026-10-03 export; do not claim later edits were captured.
- Check installer syntax, verify the source line occurs once, and confirm the alias file can be sourced in the user's shell.
