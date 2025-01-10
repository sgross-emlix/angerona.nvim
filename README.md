# Install

## Lazy

```lua
{
  "sgross-emlix/angerona.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function ()
    require('angerona').setup({
      api_key = "<API_KEY>",
      base_url = "https://redmine.emlix.com",
  })
  end
}
```
