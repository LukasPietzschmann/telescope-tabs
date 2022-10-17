# telescope-tabs
Fly through your tabs in neovim ✈️

<p align="center">
	<img src="https://user-images.githubusercontent.com/49213919/194560309-dafa805e-3cfc-44ed-b90f-445838e2f0d8.png" width="550"  />
</p>

## Usage
You can show the picker from neovim's cmd-line by executing
```
:Telescope telescope-tabs list_tabs
```

Or straight from the plugin's path with lua
```viml
:lua require('telescope-tabs').list_tabs()
```

You can press `C-d` on any Item in the picker to close the tab (respectively all windows in it). To change the keybinding, look at [configure](https://github.com/LukasPietzschmann/telescope-tabs#configure).

## Installation
Install with your favorite Neovim package manager.

Example with packer.nvim:
```lua
use {
	'LukasPietzschmann/telescope-tabs',
	requires = { 'nvim-telescope/telescope.nvim' },
	config = function()
		require'telescope-tabs'.setup{
			-- Your custom config :^)
		}
	end
}
```
## Configure
Options can be set by calling the setup function. The following things can be changed:

### entry_formatter
This changes how a tab is represented in the picker. By default the following function is used:
```lua
entry_formatter = function(tab_id, buffer_ids, file_names, file_paths)
	local entry_string = table.concat(file_names, ', ')
	return string.format('%d: %s', tab_id, entry_string)
end,
```
To alter this behaviour, just assign your own function.

### show_preview
This controls whether a preview is shown or not. The default is `true`:
```lua
show_preview = true,
```

### close_tab_shortcut
This shortcut allows you to close a selected tabs right from the picker. The default is...
```lua
close_tab_shortcut = '<C-d>',
```
Note, that this value does not get parsed or checked, so it should follow the regular format for keybindings.

## Documentation
See [telescope-tabs.txt](https://github.com/LukasPietzschmann/telescope-tabs/blob/master/doc/telescope-tabs.txt).
