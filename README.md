> Translate this file into your native language using `Google Translate` or a [similar service](https://immersivetranslate.com).

# CSSVarViewer

Este plugin para **Neovim** te permite identificar fácilmente el valor de las variables CSS que has definido previamente en tus archivos de estilo, como `main.css` o `style.css`. Cuando el plugin detecta una variable CSS en estos archivos, la muestra en un texto virtual, lo que facilita su visualización desde cualquier otro archivo.

## 🗒️ Requerimientos

* [`Neovim`](https://github.com/neovim/neovim): Versión 0.7 o superior.

### Instalación

Usando [`folke/lazy.nvim`](https://github.com/folke/lazy.nvim):

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

## 🗒️ Configuración

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

Puedes ampliar la búsqueda de archivos hacia un directorio específico o analizar otros archivos utilizando el comando `:CSSVarViewer`, cuya sintaxis es la misma que la utilizada en [`CSSVarHighlight`](https://github.com/farias-hecdin/CSSVarHighlight#comandos-y-atajos-de-teclado). Es decir:

```sh
:CSSVarViewer <filename> <attempt_limit | dir>
```

Si deseas pegar el valor del texto virtual, selecciona la variable CSS en modo visual (por ejemplo, `var(--primary-rgb)`) y luego presiona `<leader>cv` o utiliza el comando `:CSSVarViewer`.

## 🛡️ Licencia

CSSVarViewer está bajo la licencia MIT. Consulta el archivo `LICENSE` para obtener más información.
