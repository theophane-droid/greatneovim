local zoom_tab = nil

local function toggle_zoom()
  if not zoom_tab then
    vim.cmd("tab split")
    zoom_tab = vim.api.nvim_get_current_tabpage()
    return
  end

  if vim.api.nvim_get_current_tabpage() ~= zoom_tab then
    vim.api.nvim_set_current_tabpage(zoom_tab)
  end

  vim.cmd("tabclose")
  zoom_tab = nil
end

local function is_zoomed()
  return zoom_tab ~= nil and vim.api.nvim_get_current_tabpage() == zoom_tab
end

return {
  toggle_zoom = toggle_zoom,
  is_zoomed   = is_zoomed,
}
