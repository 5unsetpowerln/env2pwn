-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

-- mapping for copy and paste
vim.cmd [[
  nnoremap gj j 
  nnoremap gk k 
  nnoremap <Return><Return> <c-w><c-w>
]]

if vim.g.neovide then
  vim.o.guifont = "M+1Code Nerd Font:h10:i"
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0
end
