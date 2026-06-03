local constants = require("kuba.plugins.ai.codecompanion.constants")

local function read_file(path)
  local file = io.open(path, "r")
  if not file then
    return ""
  end

  local content = file:read("*a")
  file:close()

  return content
end

return function(ctx)
  local karpathy_guidelines = read_file(constants.KARPATHY_GUIDELINES)
  if karpathy_guidelines ~= "" then
    karpathy_guidelines = "\n\n" .. karpathy_guidelines
  end

  return ctx.default_system_prompt .. karpathy_guidelines
end
