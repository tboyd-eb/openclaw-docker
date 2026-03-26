export PATH="/home/node/npm/bin:/home/node/.local/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
export DOCKER_HOST="tcp://socat:2375"
export PROFILE_LOADED=1

# Interactive login shells: also load ~/.bashrc (aliases, etc.)
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
