local constants = require("kuba.plugins.ai.codecompanion.constants")

return {
  servers = {
    ["sequential-thinking"] = {
      cmd = { "npx", "-y", "@modelcontextprotocol/server-sequential-thinking" },
    },
    obsidian = {
      cmd = { "npx", "-y", "@bitbonsai/mcpvault@latest", constants.OBSIDIAN_VAULT },
    },
    context7 = {
      cmd = { "npx", "-y", "@upstash/context7-mcp" },
    },
    memory = {
      cmd = { "npx", "-y", "@modelcontextprotocol/server-memory" },
    },
    playwright = {
      cmd = { "npx", "-y", "@playwright/mcp@latest" },
    },
    ["ui5-wcr"] = {
      cmd = { "npx", "-y", "@ui5/webcomponents-react-mcp@latest" },
    },
  },
  opts = {
    default_servers = { "memory" },
  },
}
