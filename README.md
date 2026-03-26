# OpenClaw Docker Setup

This is my OpenClaw docker-compose setup.

## Features

- Additional utility packages
  - `asciinema` - Terminal screencast
  - `chromium` - Headless browser
  - `dbus-user-session` - D-Bus user session for Chromium, etc.
  - `docker` - Run dockerized MCP tools
  - `jq` - Query/massage JSON
  - `gh` - GitHub CLI
  - `mcporter` - Standalone MCP server aggregator
  - `ripgrep` - For session transcript search
  - `sqlite3` - Query SQLite database files
  - `tmux` - Terminal manipulation via send-keys
  - `wordnet` - Dictionary, thesaurus, etc.
- Cursor as model provider (see [Other Mods](#other-mods) section)
- Canvas sidecar server for agentic UI
- OpenClaw runs as non-root user

## Quick Start

Assuming you already have Cursor auth tokens in `~/.config/cursor`:

```sh
mkdir -p home/.config
cp -R ~/.config/cursor home/.config/
cp bashrc home/.bashrc
cp bash_profile home/.bash_profile
cp chromium-wrapper home/
docker compose build
docker compose up -d
```

Shell into the running instance:

```sh
docker compose exec -it openclaw bash
```

Run the configuration wizard:

```sh
openclaw config
```

The `home/` directory is mounted to `/home/node` within the container, which is
the home directory for the user running OpenClaw. The OpenClaw installation
itself lives at `/home/node/.openclaw`, and the global npm package library
is set to `/home/node/npm`.

You will need to install my fork of the `openclaw-cursor-brain` plugin once
OpenClaw is running in order to use Cursor as your model provider. (See the
[Other Mods](#other-mods) section.)

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

## `socat` Container

A sidecar container running `socat` is used to provide the host docker socket
to the `openclaw` container. This is to work around an issue with Rancher
Desktop (my docker provider on macOS).

## Other Mods

I use a modified version of [openclaw-better-gateway][] for my chat UI, since
I cannot connect my agents to messaging platforms like Discord. It has been
extended to fix some visual issues and provide syntax highlighting for code
blocks in chat.

I also use a modified version of [openclaw-cursor-brain][] for my model
provider. It needed some adjustment to better support the `webchat` message
platform and a bit of tidying up so that it doesn't fire its entire setup
routine every time the `openclaw` CLI gets used.

I originally wrote a hacky workaround for a bug in OpenClaw so that I could
use BM25 keyword search for the `memorySearch` feature, but I eventually
abandoned that in favor of running the `nomic-embed-text-v1.5` model locally
using LMStudio. If you're interested, that project is
[openclaw-null-embeddings][].

## Version Pinning

This project currently pins OpenClaw to the `2026.3.11` release, as the plugin
architecture changed afterward. The mods mentioned above will need to be fixed
before later versions can be used.

## Extra Steps

I've done a few other things to customize my installation further:

- Set the default model for all agents to `cursor-local/composer-2` to
  _drastically_ reduce usage costs
- Added an SSH key to my GitHub settings and configured my agent to use it for
  git operations as well as setting up its global `user.name` and `user.email`
- Disabled the built-in _heartbeat_ system and replaced it with an hourly
  _cron_ system job that runs in isolation to avoid polluting main agent
  session context (later versions of OpenClaw provide isolation for
  _heartbeat_)
- Added the `fan-out` and `ritual` [skills][] from my personal projects to
  provide agents with task management and collaboration tools
- Added the [todo-mcp-server][] from my personal projects to support the
  `fan-out` skill and other task management use cases
- Added the `rooms` [extension][] from my personal projects to support the
  `ritual` skill and other broadcast use cases
- Configured a variety of MCP servers for Atlassian, Slack, AWS/CDK docs,
  GitHub, etc.

### Heartbeat cron job

<details>
<summary>Click to expand</summary>
<br />

```json
{
  "id": "2d9a5662-c9cb-4f6b-95b2-284fa33d8d9e",
  "agentId": "main",
  "name": "Hourly heartbeat (isolated)",
  "description": "Replaces gateway heartbeat: isolated session, hourly checklist Mon–Fri 9–5 America/Chicago",
  "enabled": true,
  "createdAtMs": 1774476151232,
  "updatedAtMs": 1774551616028,
  "schedule": {
    "kind": "cron",
    "expr": "0 9-17 * * 1-5",
    "tz": "America/Chicago"
  },
  "sessionTarget": "isolated",
  "wakeMode": "now",
  "payload": {
    "kind": "agentTurn",
    "message": "Hourly scheduled check (gateway heartbeat is disabled). Read HEARTBEAT.md in the workspace root and work through the checklist using tools as needed. If nothing needs user-facing follow-up, end with HEARTBEAT_OK on its own line.",
    "lightContext": true
  },
  "delivery": {
    "mode": "none",
    "channel": "last"
  },
  "state": {
    "nextRunAtMs": 1774555200000,
    "lastRunAtMs": 1774551600019,
    "lastRunStatus": "ok",
    "lastStatus": "ok",
    "lastDurationMs": 16009,
    "lastDelivered": false,
    "lastDeliveryStatus": "not-delivered",
    "consecutiveErrors": 0
  }
}
```
</details>

[extension]: https://github.com/haliphax-openclaw/extensions
[haliphax-openclaw/openclaw-canvas-web]: https://github.com/haliphax-openclaw/openclaw-canvas-web
[openclaw-better-gateway]: https://github.com/tboyd-eb/openclaw-better-gateway
[openclaw-cursor-brain]: https://github.com/tboyd-eb/openclaw-cursor-brain
[openclaw-null-embeddings]: https://github.com/tboyd-eb/openclaw-null-embeddings
[skills]: https://github.com/haliphax-openclaw/skills
[todo-mcp-server]: https://github.com/haliphax-openclaw/todo-mcp-server

