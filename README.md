# Install

```
git clone git@gitlabintern.emlix.com:hackathon/angerona.nvim ${PLUGIN_DIR}/angerona.nvim
```

## Lazy

```lua
{
  dir = vim.env.HOME .. "<PLUGIN_DIR>" .. "angerona.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function ()
  	require('angerona').setup()
  end
}

```
