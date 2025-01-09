local function create_buffer()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(buf, "*scratch*")
  vim.api.nvim_set_option_value("filetype", "lua", { buf = buf })
  return buf
end

local function main()
  print("Hello from our plugin")
  local buf = create_buffer()

  vim.api.nvim_buf_set_lines(buf, 0, -1, true, { "-- Welcome to Neovim!", "" })

  vim.api.nvim_win_set_buf(0, buf)

  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(buf), 0 })
end

local function setup()
  local augroup = vim.api.nvim_create_augroup("ScratchBuffer", { clear = true })

  vim.api.nvim_create_autocmd("VimEnter",
    { group = augroup, desc = "Set a fennel scratch buffer on load", once = true, callback = main })
end

return { setup = setup }
