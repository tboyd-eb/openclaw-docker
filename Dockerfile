FROM node:lts
USER root

# base packages
RUN apt-get update && apt-get install -y \
    asciinema \
    build-essential \
    ca-certificates \
    chromium \
    curl \
    dbus \
    dbus-user-session \
    file \
    fonts-noto-color-emoji \
    git \
    jq \
    procps \
    ripgrep \
    sqlite3 \
    tmux \
    wordnet \
    --no-install-recommends

# docker
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

RUN tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

# homebrew dir
RUN mkdir -p /home/linuxbrew/.linuxbrew && chown -R node:node /home/linuxbrew

# entry point script with bootstrap
RUN cat >/start.sh <<EOF
#!/bin/bash
set -eo pipefail

[ -f "/home/node/.npmrc" ] || {
    echo "export PATH=/home/node/npm/bin:/home/node/.local/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:\$PATH" > \$HOME/.bashrc;
    curl -LsSf https://astral.sh/uv/install.sh | sh;
    curl https://cursor.com/install -fsS | bash;
    npm config set prefix /home/node/npm;
    npm i -g openclaw@2026.3.11 clawhub mcporter;
}

dbus-daemon --session --fork --address=unix:path=/tmp/dbus-session.sock
openclaw gateway
EOF

RUN chmod 777 /start.sh

# non-root user
USER node
ENV USER=node

# install homebrew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

# homebrew packages
RUN brew install gh go gogcli

ENTRYPOINT ["/start.sh"]
