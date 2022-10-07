# telescope-tabs
Fly through your tabs in neovim ✈️

## Usage
You can show the picker from neovim's cmd-line by executing
```
:Telescope telescope-tabs list_tabs
```

Or straight from the plugin's path with lua
```viml
:lua require('telescope-tabs').list_tabs()
```

You can press `C-d` on any Item in the picker to close the tab (respectively all windows in it).

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
