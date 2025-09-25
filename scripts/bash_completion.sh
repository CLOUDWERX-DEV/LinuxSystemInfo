#!/bin/bash

# Bash completion for sysinfo commands
# To install, add this to your ~/.bashrc:
# source /home/cloudwerxlab/Desktop/LinuxSystemInfo/scripts/bash_completion.sh

_sysinfo_complete() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Basic completion - no arguments needed for now
    opts=""
    
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

# Register completion for both commands
complete -F _sysinfo_complete sysinfo
complete -F _sysinfo_complete sysinfo-simple

# Also add helpful aliases
alias si='sysinfo'
alias sis='sysinfo-simple'
alias sys='sysinfo'