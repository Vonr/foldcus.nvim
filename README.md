# foldcus.nvim

### foldcus.nvim is a minimal plugin for NeoVim for folding multiline comments

### Installation

Packer
```lua
use {
    'Vonr/foldcus.nvim',
    requires = { 'nvim-treesitter/nvim-treesitter' }
}
```

### Usage

Bind the functions to your preferred bindings and use them in Normal mode.

This plugin does not and will not provide any default mappings or commands for the foreseeable future.

Suggested mappings:

```lua
local foldcus = require('foldcus')
local NS = { noremap = true, silent = true }

-- Fold multiline comments longer than or equal to 4 lines
vim.keymap.set('n', 'z;', function() foldcus.fold(4)   end, NS)

-- Fold multiline comments longer than or equal to the number of lines specified by args
-- e.g. Foldcus 4
vim.api.nvim_create_user_command('Foldcus', function(args) foldcus.fold(tonumber(args.args))   end, { nargs = '*' })

-- Delete folds of multiline comments longer than or equal to 4 lines
vim.keymap.set('n', 'z\'', function() foldcus.unfold(4) end, NS)

-- Delete folds of multiline comments longer than or equal to the number of lines specified by args
-- e.g. Unfoldcus 4
vim.api.nvim_create_user_command('Unfoldcus', function(args) foldcus.unfold(tonumber(args.args)) end, { nargs = '*' })
```

![Usage Gif](https://user-images.githubusercontent.com/24369412/194706028-15cc6dec-ed13-4bf1-8761-e8e92bb09ca2.gif)
