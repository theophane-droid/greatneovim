local zoom_state = {
  active = false,
  origin_tab = nil,
  zoom_tab   = nil,
}

local function toggle_zoom()
  local curtab = vim.api.nvim_get_current_tabpage()

  if not zoom_state.active then
    zoom_state.origin_tab = curtab

    vim.cmd("tab split")  
    zoom_state.zoom_tab = vim.api.nvim_get_current_tabpage()
    zoom_state.active = true
    return
  end

  if zoom_state.active then
    if zoom_state.zoom_tab and vim.api.nvim_tabpage_is_valid(zoom_state.zoom_tab) then
      vim.api.nvim_set_current_tabpage(zoom_state.zoom_tab)
      vim.cmd("tabclose")
    end

    if zoom_state.origin_tab and vim.api.nvim_tabpage_is_valid(zoom_state.origin_tab) then
      vim.api.nvim_set_current_tabpage(zoom_state.origin_tab)
    end

    zoom_state.active = false
    zoom_state.origin_tab = nil
    zoom_state.zoom_tab   = nil
  end
end

local function is_zoomed()
  return zoom_state.active
     and zoom_state.zoom_tab
     and vim.api.nvim_tabpage_is_valid(zoom_state.zoom_tab)
     and vim.api.nvim_get_current_tabpage() == zoom_state.zoom_tab
end

return {
  toggle_zoom = toggle_zoom,
  is_zoomed   = is_zoomed,
}
