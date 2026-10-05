#!/bin/sh
# Install portable aliases and, on macOS, VS Code user keybindings.
set -eu

setup_source_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
setup_home=${HOME:?HOME must be set}
setup_target=auto
setup_shell=auto
setup_vscode_user_dir=
setup_backup_dir=
setup_changes=0

usage() {
    cat <<'HELP'
Usage: sh install.sh [--mac | --remote] [--shell bash | zsh]
                     [--home DIR] [--vscode-user-dir DIR]

On macOS: installs aliases and the bundled VS Code user shortcuts.
On a remote host: installs aliases only. Local VS Code owns the shortcuts.
Existing files are backed up before modification. Re-running is safe.
HELP
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --mac) setup_target=mac; shift ;;
        --remote) setup_target=remote; shift ;;
        --shell)
            [ "$#" -ge 2 ] || { usage >&2; exit 2; }
            setup_shell=$2; shift 2 ;;
        --home)
            [ "$#" -ge 2 ] || { usage >&2; exit 2; }
            setup_home=$2; shift 2 ;;
        --vscode-user-dir)
            [ "$#" -ge 2 ] || { usage >&2; exit 2; }
            setup_vscode_user_dir=$2; shift 2 ;;
        -h|--help) usage; exit 0 ;;
        *) usage >&2; exit 2 ;;
    esac
done

if [ "$setup_target" = auto ]; then
    case "$(uname -s)" in Darwin) setup_target=mac ;; *) setup_target=remote ;; esac
fi
if [ "$setup_shell" = auto ]; then
    case "${SHELL-}" in
        */zsh) setup_shell=zsh ;;
        */bash) setup_shell=bash ;;
        *)
            if [ "$setup_target" = mac ]; then setup_shell=zsh; else setup_shell=bash; fi
            ;;
    esac
fi
case "$setup_shell" in
    bash) setup_rc="$setup_home/.bashrc" ;;
    zsh)
        setup_rc="${ZDOTDIR:-$setup_home}/.zshrc"
        # An explicit alternate home is an isolated target, not the live ZDOTDIR.
        if [ "$setup_home" != "$HOME" ]; then setup_rc="$setup_home/.zshrc"; fi
        ;;
    *) printf '%s\n' 'Only Bash and Zsh are supported.' >&2; exit 2 ;;
esac

backup_file() {
    if [ ! -e "$1" ]; then return; fi
    if [ -z "$setup_backup_dir" ]; then
        setup_backup_dir="$setup_home/.local/state/vscode-portable-setup/backups/$(date -u +%Y%m%dT%H%M%SZ)-$$"
        mkdir -p "$setup_backup_dir"
    fi
    cp -p "$1" "$setup_backup_dir/$2"
}

install_file() {
    if [ -f "$2" ] && cmp -s "$1" "$2"; then return; fi
    backup_file "$2" "$3"
    mkdir -p "$(dirname -- "$2")"
    cp "$1" "$2"
    setup_changes=$((setup_changes + 1))
    printf 'Installed: %s\n' "$2"
}

install_file "$setup_source_dir/portable-aliases.sh" "$setup_home/.portable-aliases.sh" portable-aliases.sh
setup_source_line='[ -f "$HOME/.portable-aliases.sh" ] && . "$HOME/.portable-aliases.sh"'
if [ ! -f "$setup_rc" ] || ! grep -Fqx "$setup_source_line" "$setup_rc"; then
    backup_file "$setup_rc" "$setup_shell.rc"
    mkdir -p "$(dirname -- "$setup_rc")"
    printf '\n# Portable aliases\n%s\n' "$setup_source_line" >> "$setup_rc"
    setup_changes=$((setup_changes + 1))
    printf 'Updated: %s\n' "$setup_rc"
fi

if [ "$setup_target" = mac ]; then
    if [ -z "$setup_vscode_user_dir" ]; then
        setup_vscode_user_dir="$setup_home/Library/Application Support/Code/User"
    fi
    install_file "$setup_source_dir/keybindings.json" "$setup_vscode_user_dir/keybindings.json" keybindings.json
fi

if [ -n "$setup_backup_dir" ]; then printf 'Backups: %s\n' "$setup_backup_dir"; fi
if [ "$setup_changes" -eq 0 ]; then printf '%s\n' 'Already up to date.'; fi
printf '%s\n' 'Open a new terminal to load the aliases.'
