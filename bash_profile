export DBUS_SESSION_BUS_ADDRESS="unix:path=/tmp/dbus-session.sock"
export DOCKER_HOST="tcp://socat:2375"
export OPENCLAW_CONFIG_DIR="/home/node/.openclaw"
export OPENCLAW_WORKSPACE_DIR="/home/node/.openclaw/workspace"
export PATH="/home/node/npm/bin:/home/node/.local/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
export PROFILE_LOADED=1

# Interactive login shells: also load ~/.bashrc (aliases, etc.)
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
