local function shellescape(value)
  return vim.fn.shellescape(tostring(value))
end

return {
  extends = "cmd_tool",
  name = "react_doctor",
  description = "Validate React projects with the React Doctor CLI. Use staged/diff modes when the user asks to check specific changed files.",
  opts = {
    require_approval_before = true,
  },
  system_prompt = [[Run React Doctor to audit React code for state/effects, performance, architecture, security, and accessibility issues.

Important usage notes:
- React Doctor scans a project directory, staged files, changed files via --diff, or a named workspace project.
- It does not currently expose a documented arbitrary single-file scan option.
- If the user asks to validate one specific file, prefer mode="staged" when only that file is staged, or mode="diff" when it is changed relative to a base branch. Otherwise run mode="workspace" and report findings relevant to that file path.
- Prefer json=true for machine-readable output.
- Prefer offline=true to avoid telemetry unless the user asks otherwise.]],
  schema = {
    type = "object",
    properties = {
      mode = {
        type = "string",
        enum = { "workspace", "diff", "staged", "project", "score" },
        description = "workspace scans the project directory, diff scans files changed vs a base branch, staged scans staged files, project selects a workspace project, score returns only the score.",
      },
      directory = {
        type = "string",
        description = "Project root directory to scan. Defaults to the current working directory.",
      },
      base = {
        type = "string",
        description = "Base branch/ref for diff mode, e.g. main or origin/main.",
      },
      project = {
        type = "string",
        description = "Workspace project name for project mode.",
      },
      fail_on = {
        type = "string",
        enum = { "error", "warning", "none" },
        description = "Exit with failure on diagnostics at this level. Defaults to none for agent usage.",
      },
      json = {
        type = "boolean",
        description = "Output a structured JSON report. Defaults to true, except score mode.",
      },
      offline = {
        type = "boolean",
        description = "Skip telemetry. Defaults to true.",
      },
      verbose = {
        type = "boolean",
        description = "Show every rule and per-file details.",
      },
    },
    required = { "mode" },
  },
  build_cmd = function(args)
    local directory = args.directory or vim.fn.getcwd()
    local cmd = { "npx", "-y", "react-doctor@latest", shellescape(directory) }

    if args.mode == "diff" then
      table.insert(cmd, "--diff")
      if args.base and args.base ~= "" then
        table.insert(cmd, shellescape(args.base))
      end
    elseif args.mode == "staged" then
      table.insert(cmd, "--staged")
    elseif args.mode == "project" then
      table.insert(cmd, "--project")
      table.insert(cmd, shellescape(args.project or ""))
    elseif args.mode == "score" then
      table.insert(cmd, "--score")
    else
      table.insert(cmd, "--yes")
    end

    if args.mode ~= "score" and args.json ~= false then
      table.insert(cmd, "--json")
    end
    if args.offline ~= false then
      table.insert(cmd, "--offline")
    end
    if args.verbose then
      table.insert(cmd, "--verbose")
    end

    table.insert(cmd, "--fail-on")
    table.insert(cmd, shellescape(args.fail_on or "none"))

    return table.concat(cmd, " ")
  end,
}
