local constants = require("kuba.plugins.ai.codecompanion.constants")

-- Loads the SKILL.md content for a given superpowers skill.
-- Used exclusively by the Lua workflows in this directory.
local function load(skill_name)
  local path = constants.SUPERPOWERS_SKILLS_DIR .. "/" .. skill_name .. "/SKILL.md"
  local f = io.open(path, "r")
  if not f then
    return "Skill not found: " .. skill_name
  end
  local content = f:read("*a")
  f:close()
  return content
end

return {
  brainstorming = function()
    return load("brainstorming")
  end,
  writing_plans = function()
    return load("writing-plans")
  end,
  tdd = function()
    return load("test-driven-development")
  end,
  verification = function()
    return load("verification-before-completion")
  end,
  debugging = function()
    return load("systematic-debugging")
  end,
  code_review = function()
    return load("requesting-code-review")
  end,
  finishing = function()
    return load("finishing-a-development-branch")
  end,
}
