# CSSVarViewer

This **Neovim** plugin allows the user to identify the value of
CSS variables that had been previously defined in a stylesheet file
(e.g. `main.css`, `style.css`).
Whenever this plugin detects a CSS variable a virtual text will be shown,
making it easier to visualize from any other file.

> The aim of this plugin is to allow users to centralize their CSS variables
> within a single file. This is to give a better control of editing stylesheets.

## 🗒️ Requirements

* [`Neovim`](https://github.com/neovim/neovim): 0.7 or higher.

## Installing

Using [`folke/lazy.nvim`](https://github.com/folke/lazy.nvim):

```lua
{
    'farias-hecdin/CSSVarViewer',
    ft = "css",
    config = true,
    -- If you want to configure some options, replace the previous line with:
    -- config = function()
    -- end,
}
```

## 🗒️ Configuration

These are the default configuration values:

```lua
require('CSSVarViewer').setup({
  parent_search_limit = 5,-- <number> Parent search limit (number of levels to search upwards).
  filename_to_track = "main", -- <string> Name of the file to track (e.g. "main" for main.css).
  disable_keymaps = false, -- <boolean> Indicates whether keymaps are disabled.
})
```

### Mappings

| Commands/API              | Mode     | Keymaps      | Description                                |
| ------------------------- | -------- | ------------ | ------------------------------------------ |
| `CSSVarViewer` `toggle()` | `Normal` | `<leader>cv` | Toggles the plugin                         |
| `paste_value()`           | `Visual` | `<leader>cv` | Will paste the virtual text at the cursor  |

> [!IMPORTANT]
> The data will only be updated when the files containing the CSS variables are saved.

You can search other files/directories using the `:CSSVarViewer` command,
which uses similar syntax as [`CSSVarHighlight`](https://github.com/farias-hecdin/CSSVarHighlight#comandos-y-atajos-de-teclado).

For example:

```sh
:CSSVarViewer <filename> <attempt_limit OR directory>
```

If you wish to paste the value of the virtual text you must select the CSS variable **on Visual
mode** (e.g. `var(--primary-rgb)`), then either press `<leader>cv` or using the `:CSSVarViewer`
command.

## 🛡️ License

`CSSVarViewer` is licensed under the MIT License.
See [`LICENSE`](./LICENSE) for more info.
