# OpenClaw Docker Setup

This is my OpenClaw docker-compose setup.

## Features

- Additional utility packages
  - `asciinema` - Terminal screencast
  - `chromium` - Headless browser
  - `dbus-user-session` - D-Bus user session for Chromium, etc.
  - `docker` - Run dockerized MCP tools
  - `jq` - Massage JSON output
  - `ripgrep` - For memory search
  - `sqlite3` - Query SQLite database files
  - `tmux` - Terminal manipulation via send-keys
  - `wordnet` - Dictionary, thesaurus, etc.
- Cursor agent (see "Other Mods" section)
- Canvas sidecar server for agentic UI
- OpenClaw runs as non-root user

## Quick Start

Assuming you already have Cursor auth tokens in `~/.config/cursor`:

```sh
mkdir -p home/.config
cp -R ~/.config/cursor home/.config/
cp bashrc home/.bashrc
cp bash_profile home/.bash_profile
docker compose build
docker compose up -d
```

The `home/` directory is mounted to `/home/node` within the container, which is
the home directory for the user running OpenClaw. The OpenClaw installation
itself lives at `/home/node/.openclaw`, and the global npm package library
is set to `/home/node/npm`.

You will need to install my fork of the `openclaw-cursor-brain` plugin once
OpenClaw is running in order to use Cursor as your model provider. (See the
"Other Mods" section.)

## Shell Environment

Any environment variables you want to stick need to go in `home/.bash_profile`.

Changes to interactive shells **only** need to go in `home/.bashrc`.

## Canvas Server

The first time you spin up the Canvas server, you will need to allow its device
pairing request. Use `openclaw devices list` to find it.

The Canvas web app is served at [http://localhost:3456](http://localhost:3456)
and will redirect to the `/main/` session by default.

The server is a personal project of mine,
[haliphax-openclaw/openclaw-canvas-web][]. See that repository for additional
information about configuring it and showing your agents how to use it.

## Other Mods

I use a modified version of [openclaw-better-gateway][] for my chat UI, since
I cannot connect my agents to messaging platforms like Discord. It has been
extended to fix some visual issues and provide syntax highlighting for code
blocks in chat.

I also use a modified version of [openclaw-cursor-brain][] for my model
provider. It needed some adjustment to better support the `webchat` message
platform and a bit of tidying up so that it doesn't fire its entire setup
routine every time the `openclaw` CLI gets used.

## Version Pinning

This project currently pins OpenClaw to the `2026.3.11` release, as the plugin
architecture changed afterward. The mods mentioned above will need to be fixed
before later versions can be used.

[haliphax-openclaw/openclaw-canvas-web]: https://github.com/haliphax-openclaw/openclaw-canvas-web
[openclaw-better-gateway]: https://github.com/tboyd-eb/openclaw-better-gateway
[openclaw-cursor-brain]: https://github.com/tboyd-eb/openclaw-cursor-brain
