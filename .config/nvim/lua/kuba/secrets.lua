--- Read a secret by name from ~/.secrets file, falling back to env vars.
---@param name string
---@return string|nil
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

return secret
