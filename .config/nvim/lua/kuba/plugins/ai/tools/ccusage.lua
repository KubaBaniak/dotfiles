local function shellescape(value)
  return vim.fn.shellescape(tostring(value))
end

return {
  extends = "cmd_tool",
  name = "ccusage",
  description = "Analyze coding (agent) CLI token usage and costs from local data across Claude Code, Codex, Copilot, etc.",
  opts = {
    require_approval_before = true,
  },
  system_prompt = [[Run ccusage to inspect token usage and costs across coding agent CLIs.

Usage guidelines:
- Subcommands: daily, weekly, monthly, session, blocks.
- Optional date filters: since (YYYY-MM-DD), until (YYYY-MM-DD).
- Prefer json=true for structured machine-readable reports.
- Prefer offline=true to use cached pricing data.]],
  schema = {
    type = "object",
    properties = {
      command = {
        type = "string",
        enum = { "daily", "weekly", "monthly", "session", "blocks" },
        description = "Usage report view: daily (default), weekly, monthly, session, or blocks (5-hour billing windows).",
      },
      since = {
        type = "string",
        description = "Filter from date (YYYY-MM-DD or YYYYMMDD).",
      },
      ["until"] = {
        type = "string",
        description = "Filter until date inclusive (YYYY-MM-DD or YYYYMMDD).",
      },
      json = {
        type = "boolean",
        description = "Output in structured JSON format. Defaults to true.",
      },
      offline = {
        type = "boolean",
        description = "Use cached pricing data. Defaults to true.",
      },
      by_agent = {
        type = "boolean",
        description = "Include per-agent breakdowns in report rows.",
      },
      compact = {
        type = "boolean",
        description = "Force compact table layout for terminal display.",
      },
    },
  },
  build_cmd = function(args)
    local cmd = { "npx", "-y", "ccusage@latest" }

    if args.command and args.command ~= "" then
      table.insert(cmd, shellescape(args.command))
    else
      table.insert(cmd, "daily")
    end

    if args.json ~= false then
      table.insert(cmd, "--json")
    end

    if args.offline ~= false then
      table.insert(cmd, "--offline")
    end

    if args.by_agent then
      table.insert(cmd, "--by-agent")
    end

    if args.compact then
      table.insert(cmd, "--compact")
    end

    if args.since and args.since ~= "" then
      table.insert(cmd, "--since")
      table.insert(cmd, shellescape(args.since))
    end

    if args["until"] and args["until"] ~= "" then
      table.insert(cmd, "--until")
      table.insert(cmd, shellescape(args["until"]))
    end

    return table.concat(cmd, " ")
  end,
}
