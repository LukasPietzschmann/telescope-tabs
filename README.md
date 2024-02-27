# telescope-tabs
Fly through your tabs in neovim ✈️

<p align="center">
	<img src="https://github.com/LukasPietzschmann/telescope-tabs/assets/49213919/e749d458-4ffd-4af2-aba9-86d0e3fb4862" width="300px" />
</p>

## Usage
You can in straight from lua:
```lua
require('telescope-tabs').list_tabs()
```

But `telescope-tabs` can not only be used for selecting an arbitrary tab! You can also call
```lua
require('telescope-tabs').go_to_previous()
```
to switch to the last opened tab immediately.
This does not only work when switching tabs with this extension, but also when you use Neovims builtin tab movement methods.

This plugin improves upon the already present `g<Tab>` shortcut by keeping track of a "last shown tab stack". Consequently, if you close the most previously visited tab, `g<Tab>` will fail. However, telescope-tabs will happily show the second last tab.

I would recommend to bind this to a shortcut if you wanna use this regularly :^)


## Installation
Install with your favorite Neovim package manager.

Example with lazy.nvim:
```lua
{
	'LukasPietzschmann/telescope-tabs',
	event = 'VeryLazy',
	opts = {
		-- Your custom config :^)
	}
}
```

Example with packer.nvim:
```lua
use {
	'LukasPietzschmann/telescope-tabs',
	config = function()
		require'telescope-tabs'.setup{
			-- Your custom config :^)
		}
	end
}
```
## Configure
Different configurations can be seen in the [configs wiki](https://github.com/LukasPietzschmann/telescope-tabs/wiki/Configs#configs). Feel free to add your own!

If you want to come up with your own config, these are the settings you can tweak:

### entry_formatter
This changes how a tab is represented. By default the following function is used:
```lua
entry_formatter = function(tab_id, buffer_ids, file_names, file_paths, is_current)
	local entry_string = table.concat(file_names, ', ')
	return string.format('%d: %s%s', tab_id, entry_string, is_current and ' <' or '')
end,
```
To alter this behaviour, just assign your own function.

## Documentation
See [telescope-tabs.txt](https://github.com/LukasPietzschmann/telescope-tabs/blob/master/doc/telescope-tabs.txt).
