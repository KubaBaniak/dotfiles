local M = {}

local state_file = vim.fn.stdpath("state") .. "/ai_disabled"

local function is_file_disabled()
  return (vim.uv or vim.loop).fs_stat(state_file) ~= nil
end

local function set_persisted_disabled(disabled)
  if disabled then
    local fd = (vim.uv or vim.loop).fs_open(state_file, "w", 438) -- 0666 in octal
    if fd then
      (vim.uv or vim.loop).fs_close(fd)
    end
  else
    pcall((vim.uv or vim.loop).fs_unlink, state_file)
  end
end

function M.is_enabled()
  if vim.g.disable_ai then
    return false
  end
  if vim.env.NVIM_NO_AI == "1" then
    return false
  end
  if is_file_disabled() then
    return false
  end
  return true
end

-- Initialize global state flag
vim.g.ai_enabled = M.is_enabled()

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "AI" })
end

function M.disable()
  set_persisted_disabled(true)
  vim.g.ai_enabled = false

  -- Silence Copilot if it is currently loaded
  local ok, copilot_command = pcall(require, "copilot.command")
  if ok and copilot_command.disable then
    copilot_command.disable()
  elseif vim.fn.exists(":Copilot") == 2 then
    pcall(vim.cmd, "Copilot disable")
  end

  notify("AI disabled (persisted across restarts)")
end

function M.enable()
  set_persisted_disabled(false)
  vim.g.ai_enabled = true

  -- If Neovim started with AI plugins loaded, re-enable Copilot immediately
  local ok, copilot_command = pcall(require, "copilot.command")
  if ok and copilot_command.enable then
    copilot_command.enable()
    notify("AI enabled")
  elseif vim.fn.exists(":Copilot") == 2 then
    pcall(vim.cmd, "Copilot enable")
    notify("AI enabled")
  else
    notify("AI enabled (will load on next Neovim start)")
  end
end

function M.toggle()
  if M.is_enabled() then
    M.disable()
  else
    M.enable()
  end
end

function M.status()
  local enabled = M.is_enabled()
  local reason = ""
  if not enabled then
    if vim.g.disable_ai then
      reason = " (via vim.g.disable_ai)"
    elseif vim.env.NVIM_NO_AI == "1" then
      reason = " (via NVIM_NO_AI env var)"
    elseif is_file_disabled() then
      reason = " (persisted in state)"
    end
  end
  notify(enabled and "AI is enabled" or ("AI is disabled" .. reason))
end

-- Commands
vim.api.nvim_create_user_command("AIToggle", M.toggle, { desc = "Toggle AI plugins on/off (persisted)" })
vim.api.nvim_create_user_command("AIDisable", M.disable, { desc = "Disable AI plugins (persisted)" })
vim.api.nvim_create_user_command("AIEnable", M.enable, { desc = "Enable AI plugins (persisted)" })
vim.api.nvim_create_user_command("AIStatus", M.status, { desc = "Check AI plugins status" })

-- Keymap in the Toggle group (<leader>t)
vim.keymap.set("n", "<leader>ta", M.toggle, { desc = "Toggle AI plugins" })

return M
