local function is_blank(line_num)
  local line = vim.fn.getline(line_num)
  return line:match("^%s*$") ~= nil
end

local function select_inner_indent_block()
  local start_line = vim.fn.line(".")
  local indent_level = vim.fn.indent(start_line)
  local end_line = start_line
  local total_lines = vim.fn.line("$")

  while end_line < total_lines do
    local next_line = end_line + 1
    if is_blank(next_line) then
      end_line = end_line + 1
    elseif vim.fn.indent(next_line) >= indent_level then
      end_line = end_line + 1
    else
      break
    end
  end

  vim.cmd(string.format("normal! %dGV%dG", start_line, end_line))
end

local function select_outer_indent_block()
  local curr_line = vim.fn.line(".")
  local indent_level = vim.fn.indent(curr_line)
  local total_lines = vim.fn.line("$")

  -- Rechercher la première ligne au-dessus avec une indentation plus faible
  local start_line = curr_line
  for l = curr_line - 1, 1, -1 do
    if is_blank(l) then
      start_line = l
    elseif vim.fn.indent(l) < indent_level then
      start_line = l
      break
    else
      start_line = l
    end
  end

  -- Rechercher la dernière ligne avec indentation >=
  local end_line = curr_line
  for l = curr_line + 1, total_lines do
    if is_blank(l) then
      end_line = l
    elseif vim.fn.indent(l) >= indent_level then
      end_line = l
    else
      end_line = l
      break
    end
  end

  vim.cmd(string.format("normal! %dGV%dG", start_line, end_line))
end

return {
  select_inner_indent_block = select_inner_indent_block,
  select_outer_indent_block = select_outer_indent_block,
}
