# Source this file from ~/.zshrc or ~/.bashrc.
# General aliases exported from your current setup.

alias a='alias'
alias bye='logout'
alias h='history'
alias j='jobs'
alias ls='ls -lG'
alias py='python3'
alias z='suspend'
alias de='deactivate'
alias gpush='git add . && git commit -m "update" && git push'

# These aliases require the corresponding tools to be installed.
alias print='enscript -2r'
alias wg='nvitop -m auto'
alias tx='tmux new-session -e "PATH=$PATH" codex'

# Reload the configuration for the shell currently in use.
# Remove previous definitions before declaring functions, so re-sourcing works.
unalias rs c 2>/dev/null || :
rs() {
    if [ -n "${ZSH_VERSION-}" ]; then
        . "${ZDOTDIR:-$HOME}/.zshrc"
    elif [ -n "${BASH_VERSION-}" ]; then
        . "$HOME/.bashrc"
    fi
}
c() {
    clear
    rs
}

# General Slurm helpers are enabled on machines with Slurm installed.
# The username is resolved on the new machine when the alias is invoked.
if command -v squeue >/dev/null 2>&1; then
    alias sb='sbatch'
    alias q='squeue -u "$USER" --format "%.18i %.9P %.21j %.2t %.8M %R"'
    alias sq='squeue --format "%.18i %.9P %.21j %.2t %.4u %.12M %R"'
    alias sca='scancel'
    alias scac='scancel "$SLURM_JOB_ID"'
    alias sj='scontrol show job'
    alias sjc='scontrol show job $(squeue -u "$USER" -h -o %i -n bash)'
    alias sjl='for portable_slurm_job in $(squeue -u "$USER" -h -o %i); do scontrol show job "$portable_slurm_job"; done'
    alias scal='squeue -u "$USER" -h -o "%i %j" | while read -r portable_slurm_job portable_slurm_name; do case "$portable_slurm_job" in ""|*[!0-9]*) continue ;; esac; if [ "$portable_slurm_name" != bash ]; then scancel "$portable_slurm_job"; fi; done'
fi
