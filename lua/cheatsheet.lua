-- BUILT-IN CHEATSHEET (live search after initial full display, toggle display)
local M = {}

local COL = 38
local GAP = " "
local cheatsheet_buf = nil
local cheatsheet_win = nil

---@param l string
---@param r string
local function row(l, r)
  r = r or ""
  return string.format("%-" .. COL .. "s%s%-" .. COL .. "s", l, GAP, r)
end

local entries = {
  row(" --- VIM / NEOVIM CHEATSHEET --- "), row(""),
  row(" --- NAVIGATION --- "),
  row("h j k l", "Left  Down  Up  Right"),
  row("w  b  e", "Word fwd / back / end"),
  row("0 ^ $", "Line start / indented / end"),
  row("gg / G", "Top / Bottom of file"),
  row("fX / tX", "Find / Till char X"),
  row("Ctrl+o / Ctrl+i", "Jump back / forward"), row(""),
  row(" --- EDITING --- "),
  row("i a o O", "Insert modes"),
  row("x / s", "Del / Substitute char"),
  row("dw dd D", "Del word, line, to EOL"),
  row("c<motion> / cc", "Change with motion / line"),
  row("r<char>", "Replace single char"),
  row("yy yw y<motion>", "Yank line, word, motion"),
  row("p / P", "Paste after / before"),
  row("u / Ctrl+r", "Undo / Redo"),
  row(".", "Repeat last command"), row(""),
  row(" --- VISUAL & SEARCH --- "),
  row("v V ^V", "Visual char / line / block"),
  row("* / #", "Search next / prev of selection"),
  row(":", "Command‑line mode"), row(""),
  row(" --- EX COMMANDS (:) --- "),
  row(":w / :q / :wq", "Write / Quit / Write+Quit"),
  row(":e <file>", "Open file"),
  row(":sp / :vs", "Split horizontal / vertical"),
  row("/pat  n/N", "Search pattern next / prev"),
  row(":%s/old/new/g", "Replace all"),
  row(":help <topic>", "Open help"), row(""),
  row(" --- PLUGIN SHORTCUTS --- "),
  row("<L>w / q / x", "Save / Quit / Save+Quit"),
  row("<L>e", "Toggle NvimTree"),
  row("<L>ff / fg", "Find files / Live grep"),
  row("<L>fb", "Buffer list"),
  row("<L>ns", "Stop hlsearch"),
  row("<L>n / ln", "Toggle rel / abs numbers"),
  row("gl gd gr", "Diagnostics / Def / Refs (LSP)"),
  row("K / <L>rn", "Hover / Rename (LSP)"),
  row("<L>ca / f", "Code action / Format"),
  row("[d  ]d", "Prev / Next diagnostic"), row(""),
  row(" --- WINDOWS --- "),
  row("Ctrl+h j k l", "Move between windows"),
  row("Ctrl+Arrows", "Resize windows"),
  row("<L>h / l", "Dec / Inc width"),
  row("<L>k / j", "Inc / Dec height"), row(""),
  row(" --- INDENT --- "),
  row("V > / <", "Indent / Dedent visual"),
  row("'.'", "Repeat last action"), row(""),
  row(" --- COMMENT --- "),
  row("gcc", "Toggle line comment"),
  row("gc  (visual)", "Toggle selection comment"), row(""),
  row(" --- MISC --- "),
  row("D / A", "Del to EOL / Append at EOL"),
  row("ciw", "Change inner word"),
  row("q<r>", "Start recording macro (register r)"),
  row("q", "Stop recording macro"),
  row("@<r>", "Play macro from register r"),
  row("<n>@<r>", "Play macro n times"),
  row(""),
  row("Close with <space>cs"),
}
---@param list string[] @entries
---@param query string @search query
local function filter_entries(list, query)
  if not query or query == "" then return list end
  local out = {}
  for _, line in ipairs(list) do
    if line:lower():match(query:lower()) then
      table.insert(out, line)
    end
  end
  if #out == 0 then
    table.insert(out, " No result for: " .. query)
  end
  return out
end

function M.show()
  -- Toggle: close if already open
  if cheatsheet_win and vim.api.nvim_win_is_valid(cheatsheet_win) then
    vim.api.nvim_win_close(cheatsheet_win, true)
    cheatsheet_win = nil
    cheatsheet_buf = nil
    return
  end

  local editor_width = vim.o.columns
  local win_width = 80

  cheatsheet_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(cheatsheet_buf, 0, -1, false, entries)

  cheatsheet_win = vim.api.nvim_open_win(cheatsheet_buf, true, {
    relative = 'editor',
    row = 3,
    col = editor_width - win_width - 2,
    width = win_width,
    height = #entries + 2,
    border = 'single',
    style = 'minimal',
  })

  vim.bo[cheatsheet_buf].filetype = 'markdown'
  vim.bo[cheatsheet_buf].modifiable = false

  -- vim.defer_fn(function()
  --   vim.ui.input({ prompt = "Search cheatsheet: " }, function(input)
  --     if input == nil then return end
  --     local filtered = filter_entries(entries, input)
  --     vim.bo[cheatsheet_buf].modifiable = true
  --     vim.api.nvim_buf_set_lines(cheatsheet_buf, 0, -1, false, filtered)
  --     vim.bo[cheatsheet_buf].modifiable = false
  --     vim.api.nvim_win_set_height(cheatsheet_win, #filtered + 2)
  --   end)
  -- end, 100)
end

return M
