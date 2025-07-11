local term_buf, term_win, term_height, term_job

-- terminal toggle ------------------------------------------------------------
vim.api.nvim_create_autocmd("WinResized", {
  callback = function()
    if term_win and vim.api.nvim_win_is_valid(term_win) then
      term_height = vim.api.nvim_win_get_height(term_win)
    end
  end,
})

function ToggleTerminal()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    if vim.api.nvim_get_current_win() == term_win then
      term_height = vim.api.nvim_win_get_height(term_win)
      vim.api.nvim_win_close(term_win, true)
      term_win = nil
    else
      vim.api.nvim_set_current_win(term_win)
    end
    return
  end

  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = vim.api.nvim_create_buf(false, true)
  end

  local h   = term_height or math.floor(vim.o.lines / 3)
  h         = math.min(h, vim.o.lines - 2)
  local row = vim.o.lines - h - 1

  term_win = vim.api.nvim_open_win(term_buf, true, {
    relative = "editor",
    row      = row,
    col      = 0,
    width    = vim.o.columns,
    height   = h,
    anchor   = "NW",
    style    = "minimal",
    border   = "single",
  })

  if vim.api.nvim_buf_get_option(term_buf, "buftype") ~= "terminal" then
    term_job = vim.fn.termopen(os.getenv("SHELL"))
    vim.api.nvim_buf_set_option(term_buf, "filetype", "terminal")
  end
end

vim.keymap.set("n", "<leader>t", ToggleTerminal, { noremap = true, silent = true })

-- helpers --------------------------------------------------------------------
local function ensure_terminal()
  if not term_win or not vim.api.nvim_win_is_valid(term_win) then
    ToggleTerminal()
  elseif vim.api.nvim_get_current_win() ~= term_win then
    vim.api.nvim_set_current_win(term_win)
  end
  return term_job
end

local function launch_file_path()
  return vim.fn.getcwd() .. "/launch.json"
end

local function ensure_launch_file()
  local launch = launch_file_path()
  if vim.fn.filereadable(launch) == 0 then
    vim.fn.writefile({
      '{',
      '  "configurations": [',
      '    { "name": "run1", "cmd": "echo run 1" },',
      '    { "name": "run2", "cmd": "echo run 2" },',
      '    { "name": "run3", "cmd": "echo run 3" }',
      '  ]',
      '}',
    }, launch)
  end
end

-- runners --------------------------------------------------------------------
local function run_launch(idx)
  ensure_launch_file()
  local cfgs = vim.fn.json_decode(table.concat(vim.fn.readfile(launch_file_path()), "\n")).configurations or {}
  local cfg  = cfgs[idx] or cfgs[1]
  local cmd  = (cfg and (cfg.cmd or cfg.command)) or "echo 'no cmd defined'"
  vim.api.nvim_chan_send(ensure_terminal(), cmd .. "\n")
end

-- popup menu -----------------------------------------------------------------
local function run_menu()
  ensure_launch_file()
  local cfgs = vim.fn.json_decode(table.concat(vim.fn.readfile(launch_file_path()), "\n")).configurations or {}
  if #cfgs == 0 then return end

  -- build lines and width
  local lines, width = {}, 0
  for i, c in ipairs(cfgs) do
    local l = string.format("%d. %s", i, c.name or ("run" .. i))
    lines[#lines + 1] = l
    width = math.max(width, #l)
  end

  -- scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row      = math.floor((vim.o.lines - (#lines + 2)) / 2),
    col      = math.floor((vim.o.columns - (width + 4)) / 2),
    width    = width + 4,
    height   = #lines + 2,
    border   = "single",
    style    = "minimal",
  })

  -- local mappings
  local function close() if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end end
  vim.keymap.set("n", "q", close, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<CR>", function()
    local l = vim.fn.line(".")
    close()
    run_launch(l)
  end, { buffer = buf })
end

-- keymaps --------------------------------------------------------------------
vim.keymap.set("n", "<leader>r", run_menu, { desc = "Run menu", noremap = true, silent = true })

-- misc -----------------------------------------------------------------------
local function open_launch()
  ensure_launch_file()
  vim.cmd("edit " .. vim.fn.fnameescape(launch_file_path()))
end

-- exports --------------------------------------------------------------------
local M = {
  run_launch      = run_launch,
  run_menu        = run_menu,
  toggle_terminal = ToggleTerminal,
  open_launch     = open_launch,
}

return M
