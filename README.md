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

# Usage

## Read Ticket

`:RedmineReadTicket [TICKET_ID]`

If no `TICKET_ID` was specified it will be extracted from git branch name and a
prompt will be shown if this also fails.

A new buffer will be shown with issue subject on the first line and the
description after a black line.

## Update Ticket

First get the issue buffer as described in `Read Ticket`.
Then make your changes and call

`:RedmineUpdateTicket`

## Create Task

`:RedmineCreateTask [TICKET_ID]`

If no `TICKET_ID` was specified it will be extracted from git branch name and a
prompt will be shown if this also fails.

A prompt will be shown for subject and description.
