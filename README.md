> [!TIP]
> Use `Google Translate` to read this file in your native language.

# CSSVarViewer

Este plugin para **Neovim** te permite identificar fácilmente el valor de una variable CSS previamente definida en tus archivos de estilo, como `main.css` o `style.css`. Cuando el plugin detecta una variable CSS en estos archivos, la muestra en un texto virtual, lo que facilita su visualización desde cualquier otro archivo.

## Requerimientos

* [`Neovim`](https://github.com/neovim/neovim): Versión 0.7 o superior.
* [`CSSPluginHelpers`](https://github.com/farias-hecdin/CSSPluginHelpers): Funciones esenciales para el plugin.

### Instalación

Usando [`folke/lazy.nvim`](https://github.com/folke/lazy.nvim):

```lua
{
    'farias-hecdin/CSSVarViewer',
    ft = "css",
    dependencies = {
        "farias-hecdin/CSSPluginHelpers",
    },
    config = true,
    -- If you want to configure some options, replace the previous line with:
    -- config = function()
    -- end,
}
```

## Configuración

Estas son las opciones de configuración predeterminadas:

```lua
require('CSSVarViewer').setup({
  -- <number> Parent search limit (number of levels to search upwards)
  parent_search_limit = 5,
  -- <string> Name of the file to track (e.g. "main" for main.css)
  filename_to_track = "main",
  -- <boolean> Indicates whether keymaps are disabled
  disable_keymaps = false,
})
```

### Comandos y atajos de teclado

| Comandos       | Modo     | Atajos de teclado | Descripción                         |
| ---------------|----------|------------------ | ----------------------------------- |
| `CSSVarViewer` | `Normal` | `<leader>cv`      | Activa el plugin y actualiza los datos |
| `CSSVarViewer` | `Visual` | `<leader>cv`      | Pega el texto virtual en el cursor |

Puedes ampliar la búsqueda de archivos hacia arriba o seleccionar otro archivo utilizando el comando `:CSSVarViewer`, similar a [`CSSVarHighlight`](https://github.com/farias-hecdin/CSSVarHighlight)

Para pegar el valor del texto virtual en el cursor, selecciona la variable en modo visual (por ejemplo, `var(--primary-rgb)`) y luego oprime `<leader>cv` o utiliza el comando `:CSSVarViewer`.

## Licencia

CSSVarViewer está bajo la licencia MIT. Consulta el archivo `LICENSE` para obtener más información.
