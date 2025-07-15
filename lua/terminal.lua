local term_height = nil
local terminals   = {}
local last_idx    = 1

-- keep height on resize
vim.api.nvim_create_autocmd("WinResized", {
  callback = function()
    for _, t in pairs(terminals) do
      if t.win and vim.api.nvim_win_is_valid(t.win) then
        term_height = vim.api.nvim_win_get_height(t.win)
        break
      end
    end
  end,
})

-- helpers --------------------------------------------------------------------
local function create_window(buf, idx)
  local h = term_height or math.floor(vim.o.lines / 3)
  h       = math.min(h, vim.o.lines - 2)
  return vim.api.nvim_open_win(buf, true, {
    relative  = "editor",
    row       = vim.o.lines - h - 1,
    col       = 0,
    width     = vim.o.columns,
    height    = h,
    border    = "single",
    style     = "minimal",
    title     = (" Term %d "):format(idx),
    title_pos = "center",
  })
end

-- open / focus ---------------------------------------------------------------
local function open_terminal(idx)
  last_idx = idx
  local t  = terminals[idx]

  if t and vim.api.nvim_buf_is_valid(t.buf) then
    -- focus existing or recreate window
    if t.win and vim.api.nvim_win_is_valid(t.win) then
      vim.api.nvim_set_current_win(t.win)
    else
      t.win = create_window(t.buf, idx)
    end
    -- restart shell if needed
    if not t.job or vim.fn.jobwait({ t.job }, 0)[1] ~= -1 then
      vim.api.nvim_set_current_win(t.win)
      t.job = vim.fn.termopen(os.getenv("SHELL"))
    end
    return t
  end

  -- new terminal -------------------------------------------------------------
  local buf = vim.api.nvim_create_buf(false, true)
  local win = create_window(buf, idx)
  vim.api.nvim_buf_set_option(buf, "filetype", "terminal")
  local job = vim.fn.termopen(os.getenv("SHELL"))

  terminals[idx] = { win = win, buf = buf, job = job }
  return terminals[idx]
end

-- toggle ---------------------------------------------------------------------
local function toggle_terminal(idx)
  if idx then -- explicit index
    local t = terminals[idx]
    if t and t.win and vim.api.nvim_win_is_valid(t.win) then
      term_height = vim.api.nvim_win_get_height(t.win)
      vim.api.nvim_win_close(t.win, true)
      t.win = nil
    else
      open_terminal(idx)
    end
    return
  end

  -- global toggle
  local any_open = false
  for _, t in pairs(terminals) do
    if t.win and vim.api.nvim_win_is_valid(t.win) then
      any_open = true
      term_height = vim.api.nvim_win_get_height(t.win)
      vim.api.nvim_win_close(t.win, true)
      t.win = nil
    end
  end
  if not any_open then open_terminal(last_idx) end
end

local function ensure_terminal(idx)
  idx = idx or 1
  local t = open_terminal(idx)
  if not t.job or vim.fn.jobwait({ t.job }, 0)[1] ~= -1 then
    t.job = vim.fn.termopen(os.getenv("SHELL"))
  end
  return t.job
end

-- launch helpers -------------------------------------------------------------
local function launch_file() return vim.fn.getcwd() .. "/launch.json" end
local function ensure_launch_file()
  if vim.fn.filereadable(launch_file()) == 0 then
    vim.fn.writefile({
      '{',
      '  "configurations": [',
      '    { "name": "run1", "cmd": "echo run 1", "term": 1 },',
      '    { "name": "run2", "cmd": "echo run 2", "term": 1 },',
      '    { "name": "run3", "cmd": "echo run 3", "term": 2 }',
      '  ]',
      '}',
    }, launch_file())
  end
end

-- run configs ----------------------------------------------------------------
local function run_launch(idx)
  ensure_launch_file()
  local cfgs = vim.fn.json_decode(table.concat(vim.fn.readfile(launch_file()), "\n")).configurations or {}
  local cfg  = cfgs[idx] or cfgs[1]
  local cmd  = (cfg and (cfg.cmd or cfg.command)) or "echo 'no cmd defined'"
  local tid  = (cfg and cfg.term) or 1
  vim.api.nvim_chan_send(ensure_terminal(tid), cmd .. "\n")
end

-- pop-up run menu ------------------------------------------------------------
local function run_menu()
  ensure_launch_file()
  local cfgs = vim.fn.json_decode(table.concat(vim.fn.readfile(launch_file()), "\n")).configurations or {}
  if #cfgs == 0 then return end

  local lines, width = {}, 0
  for i, c in ipairs(cfgs) do
    local l = string.format("%d. %s (T%d)", i, c.name or ("run" .. i), c.term or 1)
    lines[#lines + 1] = l
    width = math.max(width, #l)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  local win = vim.api.nvim_open_win(buf, true, {
    relative  = "editor",
    row       = math.floor((vim.o.lines - (#lines + 2)) / 2),
    col       = math.floor((vim.o.columns - (width + 4)) / 2),
    width     = width + 4,
    height    = #lines + 2,
    border    = "single",
    style     = "minimal",
    title     = " Select run ",
    title_pos = "center",
  })

  local function close() if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end end
  vim.keymap.set("n", "q",      close, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Esc>",  close, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<CR>", function()
    local l = vim.fn.line(".")
    close()
    run_launch(l)
  end, { buffer = buf })
end

-- term switch menu -----------------------------------------------------------
local function terminal_menu()
  local ids = {}
  for i = 1, 9 do ids[#ids + 1] = ("Terminal %d"):format(i) end
  vim.ui.select(ids, { prompt = "Select terminal:" }, function(choice)
    if choice then open_terminal(tonumber(choice:match("%d+"))) end
  end)
end

-- open launch file -----------------------------------------------------------
local function open_launch()
  ensure_launch_file()
  vim.cmd("edit " .. vim.fn.fnameescape(launch_file()))
end

-- exports --------------------------------------------------------------------
return {
  toggle_terminal = toggle_terminal,
  run_launch      = run_launch,
  run_menu        = run_menu,
  terminal_menu   = terminal_menu,
  open_launch     = open_launch,
}
