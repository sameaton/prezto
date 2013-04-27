#
# Provides for an easier use of gpg-agent.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Return if requirements are not found.
if (( ! $+commands[gpg-agent] )); then
  return 1
fi

# Get the SSH support option.
zstyle -b ':prezto:module:gpg:agent' ssh-support '_gpg_agent_ssh_support' \
  || _gpg_agent_ssh_support=''

# Set the default path to the gpg-agent-info file.
_gpg_agent_info="$HOME/.gpg-agent-info"

# Start gpg-agent.
ps -U "$USER" -o 'command' | egrep -q '^gpg-agent( |$)' \
  || gpg-agent \
      --daemon \
      ${_gpg_agent_ssh_support:+'--enable-ssh-support'} \
      --write-env-file "$_gpg_agent_info" > /dev/null

chmod 600 "${_gpg_agent_info}" 2> /dev/null
source "${_gpg_agent_info}" > /dev/null

export GPG_AGENT_INFO
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK
export SSH_AGENT_PID

unset _gpg_agent_{info,ssh_support}

