local constants = require("kuba.plugins.ai.codecompanion.constants")

local function secret(name)
  local secrets_file = vim.fn.expand("~/.secrets")

  if vim.fn.filereadable(secrets_file) == 1 then
    for _, line in ipairs(vim.fn.readfile(secrets_file)) do
      local key, value = line:match("^%s*(%u[%u%d_]*)%s*=%s*(.-)%s*$")

      if key == name then
        local quote = value:sub(1, 1)
        if (quote == '"' or quote == "'") and value:sub(-1) == quote then
          value = value:sub(2, -2)
        end

        return value
      end
    end
  end

  return os.getenv(name)
end

local context7_api_key = secret("CONTEXT7_API_KEY")

return {
  servers = {
    ["sequential-thinking"] = {
      cmd = { "npx", "-y", "@modelcontextprotocol/server-sequential-thinking" },
    },
    obsidian = {
      cmd = { "npx", "-y", "@bitbonsai/mcpvault@latest", constants.OBSIDIAN_VAULT },
    },
    context7 = {
      cmd = { "npx", "-y", "@upstash/context7-mcp", "--api-key", context7_api_key },
    },
    memory = {
      cmd = { "npx", "-y", "@modelcontextprotocol/server-memory" },
    },
    -- Atlassian Rovo is a remote OAuth HTTP server; codecompanion's native MCP
    -- only speaks stdio, so bridge it with the mcp-remote proxy. The first
    -- launch opens a browser to complete the Atlassian OAuth 2.1 sign-in.
    atlassian = {
      cmd = { "npx", "-y", "mcp-remote", "https://mcp.atlassian.com/v1/mcp/authv2" },
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
