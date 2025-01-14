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
- `insecure`: allow curl to use insecure server connections, default is `false`

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
            insecure = false,
	})
	end
}
```

## File

Angerona will look for the config file name `.ang.cfg` in the following locations:
- root directory of the current `git` repository
- the users <HOME> directory

The file is named `.ang.cfg` and follows lua syntax.

See `doc/ang.cfg.example`

```lua
return {
	default_issue = 25810,
	issue_order = { "ARG", "CFG", "GIT", "BUF", "CRT", "LST" },
}
```

# Usage

## Ticket ID

Where required the ticket id will be acquired automatically.  
The ticket id will be determined by prompt if the above fails.  
The precedence is defined in code and can be configured by config file.  
The values and their meaning is documented in `doc/ang.cfg.example`

## Read Ticket

`:RedmineReadTicket [TICKET_ID]`

A new buffer will be shown with issue subject on the first line and the
description after a black line.

## Update Ticket

First get the issue buffer as described in `Read Ticket`.
Then make your changes and call

`:RedmineUpdateTicket`

## Create Task

`:RedmineCreateTask [TICKET_ID]`

A prompt will be shown for subject and description.

## Open Browser

`:RedmineOpen [TICKET_ID]`

The redmine ticket URL will be opened for the issue provided.
