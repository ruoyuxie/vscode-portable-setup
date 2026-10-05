# Portable VS Code shortcuts and shell aliases

Use this repository to set up a new local Mac and a separate remote machine.
It contains macOS VS Code keyboard shortcuts and general Bash/Zsh aliases.

The keyboard shortcuts are the saved export from **2026-10-03**. Later changes
made on the original Mac are not verified in this snapshot. To update them,
replace `keybindings.json` with the contents of **Preferences: Open Keyboard
Shortcuts (JSON)** on that Mac.

## Install on the local Mac

```sh
git clone https://github.com/ruoyuxie/vscode-portable-setup.git
cd vscode-portable-setup
sh install.sh --mac --shell zsh
```

This installs `~/.portable-aliases.sh`, adds a source line to `.zshrc`
(or `$ZDOTDIR/.zshrc` when configured), and installs the shortcuts at
`~/Library/Application Support/Code/User/keybindings.json` for standard VS Code.
Use `--shell bash` if the interactive shell is Bash.
For VS Code Insiders or a separate profile, determine the active user
`keybindings.json` location and pass its parent directory using
`--vscode-user-dir '/path/to/User'`.

## Install on the remote host

```sh
git clone https://github.com/ruoyuxie/vscode-portable-setup.git
cd vscode-portable-setup
sh install.sh --remote --shell bash
```

Use `--shell zsh` if the remote account uses Zsh. This installs aliases and
updates the corresponding shell startup file. VS Code shortcuts belong to the
local Mac, including when it connects through Remote SSH; they are not installed
in the remote VS Code server directory.

Existing files are backed up under
`~/.local/state/vscode-portable-setup/backups/` before modification.
The installer replaces the shortcut file with the bundled file rather than
merging conflicting bindings. It can be re-run without duplicate source lines.
Open a new terminal afterward. The installer does not execute any aliases.

## Included aliases

General aliases: `a`, `bye`, `h`, `j`, `ls`, `py`, `z`, `de`, `gpush`, `print`,
`wg`, `tx`, plus `rs` and `c` adapted for the current shell.
General Slurm helpers load only where `squeue` is available and use `$USER`.

- `rs` reloads the current shell configuration; `c` clears the terminal and reloads it.
- `gpush` stages all changes, commits with message `update`, and pushes.
- `tx` starts Codex inside a new tmux session; tmux and Codex must already be installed.
- `wg` requires nvitop; `print` requires enscript; `de` requires an activated environment.
- The existing `ls -lG` spelling is preserved; GNU and macOS `ls` interpret `-G` differently.

The repository excludes fixed project paths, environment activation paths,
usernames, cluster-specific accounts/partitions/GPU allocation commands,
credentials, and machine-specific terminal restoration extensions.

## Extension commands in the shortcuts

If you use the corresponding shortcuts, install the matching extensions:
Codex (`openai.chatgpt`), Python (`ms-python.python`), Python Debugger
(`ms-python.debugpy`), Live Preview (`ms-vscode.live-server`), and LaTeX Workshop
(`James-Yu.latex-workshop`). Follow VS Code's local/remote installation guidance
for each extension. The terminal shortcuts use native VS Code commands and do
not require a custom Terminal Shortcuts extension.

## Prompt for the setup agent

See [SETUP-PROMPT.txt](SETUP-PROMPT.txt). Agents should read [AGENTS.md](AGENTS.md).

## Validation

The alias file was checked in Bash and Zsh. The installer was verified with
isolated home directories for both targets, including existing-file backups,
repeat installation, and preserving remote-only VS Code files.
