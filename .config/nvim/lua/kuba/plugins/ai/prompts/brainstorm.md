---
name: Brainstorm
interaction: chat
description: Superpowers brainstorming — use the installed skill to clarify an idea before implementation.
opts:
  alias: brainstorm
tools:
  - agent
mcp_servers:
  - memory
---

## system

Read and follow the installed `brainstorming` skill before responding:
`~/.config/nvim/skills/superpowers/skills/brainstorming/SKILL.md`

This prompt explicitly requests brainstorming. Use the current skill as the source of truth, including any supporting references it asks you to read.

## user

Let's brainstorm the following idea before writing any code:
