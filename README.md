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

## Installation
Install with your favorite Neovim package manager.

Example with packer.nvim:
```lua
use {
  'LukasPietzschmann/telescope-tabs',
  requires = { 'nvim-telescope/telescope.nvim' }
}
```
