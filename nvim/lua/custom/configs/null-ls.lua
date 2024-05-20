local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,

  -- python
  null_ls.builtins.formatting.black,
  null_ls.builtins.diagnostics.ruff,
  null_ls.builtins.diagnostics.mypy,

  -- assembly
  null_ls.builtins.formatting.asmfmt,
}

null_ls.setup {
  debug = true,
  sources = sources,
}
