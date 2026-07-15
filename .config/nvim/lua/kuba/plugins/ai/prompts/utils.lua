return {
  branch_diff = function(args)
    local target = vim.fn.input("Enter target branch/commit to compare with HEAD: ")

    if target == nil or target == "" then
      return "No target provided. Please cancel the prompt and try again."
    end

    local diff = vim.system({ "git", "diff", target .. "..HEAD" }, { text = true }):wait()

    if diff.code ~= 0 then
      return "Error running git diff: " .. (diff.stderr or "Make sure the branch exists.")
    end

    if diff.stdout == "" then
      return "No changes found between " .. target .. " and HEAD."
    end

    return diff.stdout
  end,
  get_code = function(args)
    local context = args.context

    if context.is_visual then
      -- Use the visual selection
      return context.code or table.concat(context.lines, "\n")
    else
      -- Fallback: Fetch the entire buffer contents in normal mode
      local lines = vim.api.nvim_buf_get_lines(context.bufnr, 0, -1, false)
      return table.concat(lines, "\n")
    end
  end,
  review_code = function(args)
    local context = args.context
    local bufnr = context.bufnr

    -- If triggered from the chat buffer, fall back to the alternate buffer
    local chat_ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
    if chat_ft == "codecompanion" or chat_ft == "" then
      bufnr = vim.fn.bufnr("#")
    end

    if context.is_visual then
      return context.code or table.concat(context.lines, "\n")
    else
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      return table.concat(lines, "\n")
    end
  end,

  review_filetype = function(args)
    local context = args.context
    local bufnr = context.bufnr

    -- If triggered from the chat buffer, fall back to the alternate buffer
    local chat_ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
    if chat_ft == "codecompanion" or chat_ft == "" then
      bufnr = vim.fn.bufnr("#")
    end

    local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
    return ft ~= "" and ft or context.filetype
  end,
  jira_activity = function()
    -- Get current branch name
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")

    -- Get current user's name from git config
    local author = vim.fn.system("git config user.name"):gsub("\n", "")

    -- Get all commits from today by this author across ALL branches, deduplicated
    local commits = vim.fn.system(
      'git log --all --since="midnight" --author="' .. author .. '" --format="%H|%ad|%D|%s" --date=format:"%H:%M"'
    )

    local commits_output = ""
    if commits == "" then
      commits_output = "No commits yet today."
    else
      -- Parse and format each commit with its branch context
      local seen = {}
      for line in commits:gmatch("[^\n]+") do
        local hash, time, refs, subject = line:match("^([^|]+)|([^|]+)|([^|]*)|(.+)$")
        if hash and not seen[hash] then
          seen[hash] = true
          -- Extract branch names from refs, skip HEAD pointer and tags
          local branch_names = {}
          for ref in refs:gmatch("[^,]+") do
            ref = ref:match("^%s*(.-)%s*$") -- trim whitespace
            if ref ~= "" and not ref:match("^HEAD") and not ref:match("^tag:") then
              table.insert(branch_names, ref)
            end
          end
          local branch_label = #branch_names > 0 and (" [" .. table.concat(branch_names, ", ") .. "]") or ""
          commits_output = commits_output .. string.format("%s%s %s\n", time, branch_label, subject)
        end
      end
      if commits_output == "" then
        commits_output = "No commits yet today."
      end
    end

    -- Get a summary of uncommitted changes
    local diff_stat = vim.fn.system("git diff --stat")
    if diff_stat == "" then
      diff_stat = "No uncommitted changes."
    end

    return string.format(
      "Current Branch: %s\n\nCommits Today (all branches):\n%s\nUncommitted Changes Summary:\n%s",
      branch,
      commits_output,
      diff_stat
    )
  end,
  task_boundaries = function()
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
    local author = vim.fn.system("git config user.name"):gsub("\n", "")

    -- First commit today across ALL branches (Start Boundary)
    local first_commit = vim.fn
      .system(
        'git log --all --since="midnight" --author="'
          .. author
          .. '" --reverse --format="%cd" --date=format:"%H:%M" | head -n 1'
      )
      :gsub("\n", "")
    if first_commit == "" then
      first_commit = "No commits yet today"
    end

    -- Last commit today across ALL branches
    local last_commit = vim.fn
      .system('git log --all --since="midnight" --author="' .. author .. '" --format="%cd" --date=format:"%H:%M" | head -n 1')
      :gsub("\n", "")
    if last_commit == "" then
      last_commit = "No commits yet today"
    end

    -- Collect all branches that had commits today
    local branches_today = vim.fn.system(
      'git log --all --since="midnight" --author="'
        .. author
        .. '" --format="%D" | grep -oP "(?:origin/)?[\\w./-]+" | grep -v "^HEAD" | sort -u'
    )
    local branches_label = branches_today ~= "" and branches_today:gsub("\n", ", "):gsub(", $", "") or branch

    -- Check if there are uncommitted changes right now
    local is_dirty = vim.fn.system("git status --porcelain") ~= ""
    local current_time = os.date("%H:%M")

    local end_boundary = last_commit
    if is_dirty then
      -- If there are uncommitted changes, the end boundary is right NOW
      end_boundary = current_time .. " (Includes uncommitted ongoing work)"
    end

    return string.format(
      "Current Branch: %s\nBranches Worked On Today: %s\nStart Boundary (First Commit): %s\nEnd Boundary (Latest Activity): %s",
      branch,
      branches_label,
      first_commit,
      end_boundary
    )
  end,
}
