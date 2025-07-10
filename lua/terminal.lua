local term_buf, term_win

-- Open term and create if not already exists
function ToggleTerminal()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    if vim.api.nvim_get_current_win() ~= term_win then
      vim.api.nvim_set_current_win(term_win)
      return
    end
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
    return
  end

  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = vim.api.nvim_create_buf(false, true)
  end

  local h = math.floor(vim.o.lines / 3)
  term_win = vim.api.nvim_open_win(term_buf, true, {
    relative = "editor",
    col      = 0,
    width    = vim.o.columns,
    height   = h,
    anchor   = "NW",
    style    = "minimal",
    border   = "single",
  })

  if vim.api.nvim_buf_get_option(term_buf, "buftype") ~= "terminal" then
    vim.fn.termopen(os.getenv("SHELL"))
    vim.api.nvim_buf_set_option(term_buf, "filetype", "terminal")
  end
end

vim.keymap.set("n", "<leader>t", ToggleTerminal, { noremap = true, silent = true })
