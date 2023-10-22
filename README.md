# telescope-tabs
Fly through your tabs in neovim ✈️

<p align="center">
	<img src="https://github.com/LukasPietzschmann/telescope-tabs/assets/49213919/e749d458-4ffd-4af2-aba9-86d0e3fb4862" width="300px" />
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

You can press `C-d` (insert mode) or `D` (normal mode) on any Item in the picker to close the tab (respectively all windows in it). To change the keybinding, look at [configure](https://github.com/LukasPietzschmann/telescope-tabs#configure).
<p align="center">
	<img src="https://user-images.githubusercontent.com/49213919/216813167-45ca1908-b15f-4904-a441-6420d82dcb16.png" width="550"  />
</p>

But `telescope-tabs` does not only provide a picker! You can also call
```viml
:lua require('telescope-tabs').go_to_previous()
```
to switch to the last opened tab immediately.
This does not only work when switching tabs with this extension, but also when you use Neovims builtin tab movement methods.

I would recommend to bind this to a shortcut if you wanna use this regularly :^)


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
Different configurations can be seen in the [configs wiki](https://github.com/LukasPietzschmann/telescope-tabs/wiki/Configs#configs). Feel free to add your own!

If you want to come up with your own config, these are the settings you can tweak:

### entry_formatter
This changes how a tab is represented in the picker. By default the following function is used:
```lua
entry_formatter = function(tab_id, buffer_ids, file_names, file_paths, is_current)
	local entry_string = table.concat(file_names, ', ')
	return string.format('%d: %s%s', tab_id, entry_string, is_current and ' <' or '')
end,
```
To alter this behaviour, just assign your own function.

### entry_ordinal
This changes how tabs are sorted in the picker. The ordinal is also used to determine which entries match a given search query. The following function is used by default:
```lua
entry_ordinal = function(tab_id, buffer_ids, file_names, file_paths, is_current)
	return table.concat(file_names, ' ')
end,
```

### show_preview
This controls whether a preview is shown or not. The default is `true`:
```lua
show_preview = true,
```

### close_tab_shortcut
These shortcuts allow you to close a selected tabs right from the picker. The defaults are...
```lua
close_tab_shortcut_i = '<C-d>', -- if you're in insert mode
close_tab_shortcut_n = 'D',     -- if you're in normal mode
```
Note, that their value do not get parsed or checked, so they should follow the regular format for keybindings.

## Documentation
See [telescope-tabs.txt](https://github.com/LukasPietzschmann/telescope-tabs/blob/master/doc/telescope-tabs.txt).
