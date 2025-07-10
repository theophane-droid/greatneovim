local term_buf, term_win, term_height

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
    vim.fn.termopen(os.getenv("SHELL"))
    vim.api.nvim_buf_set_option(term_buf, "filetype", "terminal")
  end
end

vim.keymap.set("n", "<leader>t", ToggleTerminal, { noremap = true, silent = true })
