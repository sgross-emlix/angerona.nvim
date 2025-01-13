# Overview

```
Goddess who relieves pain and sorrow
```

Angerona aims at seamlessly integrating `redmine` task creation into every-day
`nvim` workflow. It is not - at least for now - intended to provide a full
featured `redmine` CLI integrated into `nvim`. But instead the use case is to
give the user a way of creating ad-hoc tasks as they come without interrupting
the task at hand.

# Install

## Configuration

- __`API_KEY`__: Log into your account.
	Then find the `My Account` button in the top-right corner.
	On the right side click on `Show` under `API access key`.
	Copy the key and place it to your installation setup script.

## Lazy

```lua
{
	"emlix/angerona.nvim",
	url = "https://gitlabintern.emlix.com/emlix/hackathon2025/angerona.nvim.git",
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
