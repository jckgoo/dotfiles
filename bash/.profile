#!/bin/sh
export TMPDIR='/tmp'
export PATH="${HOME}/.local/bin:${PATH}"

if [ -r "${HOME}/.gpg-agent-info" ]; then
    source "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export SSH_AGENT_PID
fi

export OMP_NUM_THREADS=4
export OMP_PROC_BIND=true
export OMP_PLACES=cores

export CHROMIUM_FLAGS='--enable-remote-extensions'
