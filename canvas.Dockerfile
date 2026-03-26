FROM node:lts
USER root

# entry point script with bootstrap
RUN cat >/start.sh <<EOF
#!/bin/bash
set -eo pipefail
PATH="/home/node/npm/bin:/home/node/.local/bin:\$PATH"

[ -d "/home/node/openclaw-canvas-web/dist" ] || {
    npm config set prefix /home/node/npm;
    cd /home/node/openclaw-canvas-web;
    npm run clean || true;
    npm run setup;
    npm run build;
    cd mcp;
    npm run build;
}

cd /home/node/openclaw-canvas-web
npx tsx /home/node/openclaw-canvas-web/src/server/index.ts
EOF

RUN chmod 777 /start.sh

# non-root user
USER node
ENTRYPOINT ["/start.sh"]
