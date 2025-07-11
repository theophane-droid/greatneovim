local term_buf, term_win, term_height, term_job

-- ============================================================================
-- TERMINAL TOGGLE
-- ============================================================================

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

  local h = term_height or math.floor(vim.o.lines / 3)
  h = math.min(h, vim.o.lines - 2)

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

-- ============================================================================
-- TERMINAL TOGGLE
-- ============================================================================

local function ensure_terminal()
  if not term_win or not vim.api.nvim_win_is_valid(term_win) then
    ToggleTerminal()
  elseif vim.api.nvim_get_current_win() ~= term_win then
    vim.api.nvim_set_current_win(term_win)
  end
  return term_job
end

local function run_launch(idx)
  local launch = vim.fn.getcwd() .. "/launch.json"

  if vim.fn.filereadable(launch) == 0 then
    vim.fn.writefile({
        '{',
          '\t"configurations": [',
            '\t\t{ "name": "run1", "cmd": "echo run 1" },',
            '\t\t{ "name": "run2", "cmd": "echo run 2" },',
            '\t\t{ "name": "run3", "cmd": "echo run 3" }',
          '\t]',
        '}',
    }, launch)
  -- todo : ajouter une ligne dans gitignore
  end

  local cfgs = vim.fn.json_decode(table.concat(vim.fn.readfile(launch), "\n")).configurations or {}
  local cfg  = cfgs[idx] or cfgs[1]
  local cmd  = (cfg and (cfg.cmd or cfg.command)) or "echo 'no cmd defined'"

  vim.api.nvim_chan_send(ensure_terminal(), cmd .. "\n")
end


local function open_launch()
  local launch = vim.fn.getcwd() .. "/launch.json"

  if vim.fn.filereadable(launch) == 0 then
    vim.fn.writefile({
        '{',
          '\t"configurations": [',
            '\t\t{ "name": "run1", "cmd": "echo run 1" },',
            '\t\t{ "name": "run2", "cmd": "echo run 2" },',
            '\t\t{ "name": "run3", "cmd": "echo run 3" }',
          '\t]',
        '}',
    }, launch)
  end

  vim.cmd("edit " .. vim.fn.fnameescape(launch))
end


local M = {
    run_launch = run_launch,
    toggle_terminal = ToggleTerminal,
    open_launch = open_launch,
}

return M
