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
	opts = {
		redmine = {
			api_key = "<API_KEY>",
			base_url = "https://redmine.emlix.com",
			insecure = false,
		},
	},
}
```

## File

Angerona will look for the config file name `.ang.cfg` in the following locations:
- root directory of the current `git` repository
- the users <HOME> directory

The file is named `.ang.cfg` and follows lua syntax.
Keys found in the first match take precedence.
Configuration files take precedence over install configuration.

See `doc/ang.cfg.example`

```lua
return {
	redmine = {
		api_key = "<API_KEY>",
		base_url = "https://redmine.emlix.com",
		default_issue = 25810,
	},
	issue_order = { "ARG", "CFG", "GIT", "BUF", "CRT", "LST" },
}
```

# Usage

## Issue ID

Where required the issue id will be acquired automatically or as a fallback by prompt.
The precedence is defined in code and can be configured by config file.  
The values and their meaning is documented in `doc/ang.cfg.example`

## Read Issue

`:RedmineRead [ISSUE_ID]`

A new buffer will be shown with issue subject on the first line and the
description after a blank line.

## Update Issue

First get the issue buffer as described in `Read Issue`.
Then make your changes and call

`:RedmineCommit`

## Create Task

`:RedmineCreate [ISSUE_ID]`

A new buffer will be shown where you have to put issue subject on the first line
and the description after a blank line.
Once you are settled finalize with

`:RedmineCommit`

## Open Browser

`:RedmineOpen [ISSUE_ID]`

The redmine issue URL will be opened in a browser via `xdg-open` for the issue provided.
