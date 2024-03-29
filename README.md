# `vim-albatross`
## Introduction
This repository contains a forked version of [plasticboy's `vim-markdown`](https://github.com/plasticboy/vim-markdown) which contains additional functionality for making it eaiser to work with Albatross.

![Example usage of vim-albatross](media/example.gif)

## Installation
This plugin relies on the command line tool part of [`go-albatross`](https://github.com/albatross-org/go-albatross/tree/master/cmd/albatross). If it hasn't already been installed, see the [installation instructions](https://github.com/albatross-org/go-albatross/tree/master/cmd/albatross#setup)

This plugin also relies on [`fzf.vim`](https://github.com/junegunn/fzf.vim) to quickly search entries.

You can check if a working version of `go-albatross` is installed if the command `albatross vim` has output.

### Vundle
In your `~/.vimrc`:

```vim
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
```

### [`vim-plug`](https://github.com/junegunn/vim-plug)

```
call plug#begin('...')
    " ... other plugins ...

    Plugin 'godlygeek/tabular'
    Plugin 'plasticboy/vim-markdown'

    " ... other plugins ...
call plug#end()
```

## Usage
Open an entry like you normally do using Albatross:

```sh
$ albatross get -p path/to/entry
```

To add a command for opening entries using the `<leader>` (in my case `;`) and the `e` character:

```
map <leader>e :call Albatross_SelectEntry()<CR>
```

For all functions available, see [Functions](#functions).

## Features
- [X] Open entries in a new tab using the `gx` command.
- [X] Syntax highlighting of all types of links: `[[Links by Titles]]`, `{{links/by/paths}}`, `[[Links by Title](with link text)]`, `{{links/by/path}(with link text)}`
- [X] Syntax highlihgting for all types of tags: `@?tag` and `@!tag`
- [X] Open entries quickly with `Albatross_SelectEntry`.
- [X] Open entries matching certain criteria with `Albatross_SelectEntryWithFilter`
- [ ] See backlinks to the current entry.
- [ ] Open a completely new entry without having to link to it (ideally like [`fzf-vim`](https://github.com/junegunn/fzf.vim))
- [ ] Create a new entry from within Vim.
- [ ] Customise the Albatross command used internally to allow different stores.
- [ ] Very inflexible, at the moment opens tabs only.
- [ ] Would be good to have default keymaps.
- [ ] Command for quickly inserting a link.

## Functions
|Function|Purpose|Example|
|--------|-------|-------|
|`Albatross_OpenEntryFromEntryName(entryname)`|Opens the entry with the given name.|`Albatross_OpenEntryFromEntryName("Meditations on Pizza")`|
|`Albatross_OpenEntryFromEntryPath(entrypath)`|Opens the entry with the given path.|`Albatross_OpenEntryFromEntryPath("food/pizza")`|
|`Albatross_SelectEntry()`|Opens a [fzf](https://github.com/junegunn/fzf) window with a list of entries.|`map <leader>e :call Albatross_SelectEntry()<CR>`|
|`Albatross_SelectEntryWithFilter(filter...)`|Opens a [fzf](https://github.com/junegunn/fzf) window with a list of entries matching the given filter, specified as arguments to the `albatross get` command.|`map <leader>e :call Albatross_SelectEntryWithFilter("--path school")<CR>` (shows list containing entries matching `albatross get --path "school"`|

## Bugs
- [ ] I'm not very good with Vimscript which is the biggest reason this is a fork rather than a plugin from the ground up. It's very messy and not idiomatic at all.
- [ ] Links aren't parsed quite correctly, edge cases like `[[Entry With (Brackets in Name)]]` and links with different link text aren't parsed quite right, though the syntax is highlighted correctly.
- [ ] Not secure: a specially named entry could be used to execute arbitrary system commands when you attempt to open it.

## How it Works
The Albatross client isn't actually implemented in Vimscript -- it communicates with `go-albatross` through the `albatross vim` command. For more information on how it works, see `albatross vim --help`.

Here's what differs from the original:

|File|What|
|----|----|
|`syntax/markdown.vim`|Support for links and tags being highlighted.|
|`ftplugin/markdown.vim`| Mainly `s:OpenUrlUnderCursor()` to add support for opening entry links. This needs refactoring.|

Additions and modifications made to the original are easy to find by searching for "`Albatross`" since it appears in comments. 

## Vim Markdown
The complete, original README of [plasticboy's `vim-markdown`](https://github.com/plasticboy/vim-markdown) is below.

Syntax highlighting, matching rules and mappings for [the original Markdown](http://daringfireball.net/projects/markdown/) and extensions.

1. [Installation](#installation)
2. [Basic usage](#basic-usage)
3. [Options](#options)
4. [Mappings](#mappings)
5. [Commands](#commands)
6. [Credits](#credits)
7. [License](#license)

### Installation

If you use [Vundle](https://github.com/gmarik/vundle), add the following lines to your `~/.vimrc`:

```vim
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
```

The `tabular` plugin must come *before* `vim-markdown`.

Then run inside Vim:

```vim
:so ~/.vimrc
:PluginInstall
```

If you use [Pathogen](https://github.com/tpope/vim-pathogen), do this:

```sh
cd ~/.vim/bundle
git clone https://github.com/plasticboy/vim-markdown.git
```

To install without Pathogen using the Debian [vim-addon-manager](http://packages.qa.debian.org/v/vim-addon-manager.html), do this:

```sh
git clone https://github.com/plasticboy/vim-markdown.git
cd vim-markdown
sudo make install
vim-addon-manager install markdown
```

If you are not using any package manager, download the [tarball](https://github.com/plasticboy/vim-markdown/archive/master.tar.gz) and do this:

```sh
cd ~/.vim
tar --strip=1 -zxf vim-markdown-master.tar.gz
```

### Basic usage

#### Folding

Folding is enabled for headers by default.

The following commands are useful to open and close folds:

- `zr`: reduces fold level throughout the buffer
- `zR`: opens all folds
- `zm`: increases fold level throughout the buffer
- `zM`: folds everything all the way
- `za`: open a fold your cursor is on
- `zA`: open a fold your cursor is on recursively
- `zc`: close a fold your cursor is on
- `zC`: close a fold your cursor is on recursively

[Options](#options) are available to disable folding or change folding style.

Try `:help fold-expr` and `:help fold-commands` for details.

#### Concealing

Concealing is set for some syntax such as bold, italic, code block and link.

Concealing lets you conceal text with other text. The actual source text is not modified. If you put your cursor on the concealed line, the conceal goes away.

[Options](#options) are available to disable or change concealing.

Try `:help concealcursor` and `:help conceallevel` for details.

### Options

#### Disable Folding

-   `g:vim_markdown_folding_disabled`

    Add the following line to your `.vimrc` to disable the folding configuration:

        let g:vim_markdown_folding_disabled = 1

    This option only controls Vim Markdown specific folding configuration.

    To enable/disable folding use Vim's standard folding configuration.

        set [no]foldenable

#### Change fold style

-   `g:vim_markdown_folding_style_pythonic`

    To fold in a style like [python-mode](https://github.com/klen/python-mode), add the following to your `.vimrc`:

        let g:vim_markdown_folding_style_pythonic = 1

    `g:vim_markdown_folding_level` setting (default 1) is set to `foldlevel`.
    Thus level 1 heading which is served as a document title is expanded by default.

-   `g:vim_markdown_override_foldtext`

    To prevent foldtext from being set add the following to your `.vimrc`:

        let g:vim_markdown_override_foldtext = 0

#### Set header folding level

-   `g:vim_markdown_folding_level`

    Folding level is a number between 1 and 6. By default, if not specified, it is set to 1.

        let g:vim_markdown_folding_level = 6

    Tip: it can be changed on the fly with:

        :let g:vim_markdown_folding_level = 1
        :edit

#### Disable Default Key Mappings

-   `g:vim_markdown_no_default_key_mappings`

    Add the following line to your `.vimrc` to disable default key mappings:

        let g:vim_markdown_no_default_key_mappings = 1

    You can also map them by yourself with `<Plug>` mappings.

#### Enable TOC window auto-fit

-   `g:vim_markdown_toc_autofit`

    Allow for the TOC window to auto-fit when it's possible for it to shrink.
    It never increases its default size (half screen), it only shrinks.

        let g:vim_markdown_toc_autofit = 1

#### Text emphasis restriction to single-lines

-   `g:vim_markdown_emphasis_multiline`

    By default text emphasis works across multiple lines until a closing token is found. However, it's possible to restrict text emphasis to a single line (i.e., for it to be applied a closing token must be found on the same line). To do so:

        let g:vim_markdown_emphasis_multiline = 0

#### Syntax Concealing

-   `g:vim_markdown_conceal`

    Concealing is set for some syntax.

    For example, conceal `[link text](link url)` as just `link text`.
    Also, `_italic_` and `*italic*` will conceal to just _italic_.
    Similarly `__bold__`, `**bold**`, `___italic bold___`, and `***italic bold***`
    will conceal to just __bold__, **bold**, ___italic bold___, and ***italic bold*** respectively.

    To enable conceal use Vim's standard conceal configuration.

        set conceallevel=2

    To disable conceal regardless of `conceallevel` setting, add the following to your `.vimrc`:

        let g:vim_markdown_conceal = 0

    To disable math conceal with LaTeX math syntax enabled, add the following to your `.vimrc`:

        let g:tex_conceal = ""
        let g:vim_markdown_math = 1

-   `g:vim_markdown_conceal_code_blocks`

    Disabling conceal for code fences requires an additional setting:

        let g:vim_markdown_conceal_code_blocks = 0

#### Fenced code block languages

-   `g:vim_markdown_fenced_languages`

    You can use filetype name as fenced code block languages for syntax highlighting.
    If you want to use different name from filetype, you can add it in your `.vimrc` like so:

        let g:vim_markdown_fenced_languages = ['csharp=cs']

    This will cause the following to be highlighted using the `cs` filetype syntax.

        ```csharp
        ...
        ```

    Default is `['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']`.

#### Follow named anchors

-   `g:vim_markdown_follow_anchor`

    This feature allows the `ge` command to follow named anchors in links of the form
    `file#anchor` or just `#anchor`, where file may omit the `.md` extension as
    usual. Two variables control its operation:

        let g:vim_markdown_follow_anchor = 1

    This tells vim-markdown whether to attempt to follow a named anchor in a link or
    not. When it is 1, and only if a link can be split in two parts by the pattern
    '#', then the first part is interpreted as the file and the second one as the
    named anchor. This also includes urls of the form `#anchor`, for which the first
    part is considered empty, meaning that the target file is the current one. After
    the file is opened, the anchor will be searched.

    Default is `0`.

-   `g:vim_markdown_anchorexpr`

        let g:vim_markdown_anchorexpr = "'<<'.v:anchor.'>>'"

    This expression will be evaluated substituting `v:anchor` with a quoted string
    that contains the anchor to visit. The result of the evaluation will become the
    real anchor to search in the target file. This is useful in order to convert
    anchors of the form, say, `my-section-title` to searches of the form `My Section
    Title` or `<<my-section-title>>`.

    Default is `''`.

#### Syntax extensions

The following options control which syntax extensions will be turned on. They are off by default.

##### LaTeX math

-   `g:vim_markdown_math`

    Used as `$x^2$`, `$$x^2$$`, escapable as `\$x\$` and `\$\$x\$\$`.

        let g:vim_markdown_math = 1

##### YAML Front Matter

-   `g:vim_markdown_frontmatter`

    Highlight YAML front matter as used by Jekyll or [Hugo](https://gohugo.io/content/front-matter/).

        let g:vim_markdown_frontmatter = 1

##### TOML Front Matter

-   `g:vim_markdown_toml_frontmatter`

    Highlight TOML front matter as used by [Hugo](https://gohugo.io/content/front-matter/).

    TOML syntax highlight requires [vim-toml](https://github.com/cespare/vim-toml).

        let g:vim_markdown_toml_frontmatter = 1

##### JSON Front Matter

-   `g:vim_markdown_json_frontmatter`

    Highlight JSON front matter as used by [Hugo](https://gohugo.io/content/front-matter/).

    JSON syntax highlight requires [vim-json](https://github.com/elzr/vim-json).

        let g:vim_markdown_json_frontmatter = 1

##### Strikethrough

-   `g:vim_markdown_strikethrough`

    Strikethrough uses two tildes. `~~Scratch this.~~`

        let g:vim_markdown_strikethrough = 1

#### Adjust new list item indent

-   `g:vim_markdown_new_list_item_indent`

    You can adjust a new list indent. For example, you insert a single line like below:

        * item1

    Then if you type `o` to insert new line in vim and type `* item2`, the result will be:

        * item1
            * item2

    vim-markdown automatically insert the indent. By default, the number of spaces of indent is 4. If you'd like to change the number as 2, just write:

        let g:vim_markdown_new_list_item_indent = 2

#### Do not require .md extensions for Markdown links

-   `g:vim_markdown_no_extensions_in_markdown`

    If you want to have a link like this `[link text](link-url)` and follow it for editing in vim using the `ge` command, but have it open the file "link-url.md" instead of the file "link-url", then use this option:

        let g:vim_markdown_no_extensions_in_markdown = 1

    This is super useful for GitLab and GitHub wiki repositories.

    Normal behaviour would be that vim-markup required you to do this `[link text](link-url.md)`, but this is not how the Gitlab and GitHub wiki repositories work. So this option adds some consistency between the two.

#### Auto-write when following link

-   `g:vim_markdown_autowrite`

    If you follow a link like this `[link text](link-url)` using the `ge` shortcut, this option will automatically save any edits you made before moving you:

        let g:vim_markdown_autowrite = 1

#### Change default file extension

-   `g:vim_markdown_auto_extension_ext`

    If you would like to use a file extension other than `.md` you may do so using the `vim_markdown_auto_extension_ext` variable:

        let g:vim_markdown_auto_extension_ext = 'txt'

#### Do not automatically insert bulletpoints

-   `g:vim_markdown_auto_insert_bullets`

    Automatically inserting bulletpoints can lead to problems when wrapping text
    (see issue #232 for details), so it can be disabled:

        let g:vim_markdown_auto_insert_bullets = 0

    In that case, you probably also want to set the new list item indent to 0 as
    well, or you will have to remove an indent each time you add a new list item:

        let g:vim_markdown_new_list_item_indent = 0

#### Change how to open new files

-   `g:vim_markdown_edit_url_in`

    By default when following a link the target file will be opened in your current buffer.  This behavior can change if you prefer using splits or tabs by using the `vim_markdown_edit_url_in` variable.  Possible values are `tab`, `vsplit`, `hsplit`, `current` opening in a new tab, vertical split, horizontal split, and current buffer respectively.  Defaults to current buffer if not set:

        let g:vim_markdown_edit_url_in = 'tab'

### Mappings

The following work on normal and visual modes:

-   `gx`: open the link under the cursor in the same browser as the standard `gx` command. `<Plug>Markdown_OpenUrlUnderCursor`

    The standard `gx` is extended by allowing you to put your cursor anywhere inside a link.

    For example, all the following cursor positions will work:

        [Example](http://example.com)
        ^  ^    ^^   ^       ^
        1  2    34   5       6

        <http://example.com>
        ^  ^               ^
        1  2               3

    Known limitation: does not work for links that span multiple lines.

-   `ge`: open the link under the cursor in Vim for editing. Useful for relative markdown links. `<Plug>Markdown_EditUrlUnderCursor`

    The rules for the cursor position are the same as the `gx` command.

-   `]]`: go to next header. `<Plug>Markdown_MoveToNextHeader`

-   `[[`: go to previous header. Contrast with `]c`. `<Plug>Markdown_MoveToPreviousHeader`

-   `][`: go to next sibling header if any. `<Plug>Markdown_MoveToNextSiblingHeader`

-   `[]`: go to previous sibling header if any. `<Plug>Markdown_MoveToPreviousSiblingHeader`

-   `]c`: go to Current header. `<Plug>Markdown_MoveToCurHeader`

-   `]u`: go to parent header (Up). `<Plug>Markdown_MoveToParentHeader`

This plugin follows the recommended Vim plugin mapping interface, so to change the map `]u` to `asdf`, add to your `.vimrc`:

    map asdf <Plug>Markdown_MoveToParentHeader

To disable a map use:

    map <Plug> <Plug>Markdown_MoveToParentHeader

### Commands

The following requires `:filetype plugin on`.

-   `:HeaderDecrease`:

    Decrease level of all headers in buffer: `h2` to `h1`, `h3` to `h2`, etc.

    If range is given, only operate in the range.

    If an `h1` would be decreased, abort.

    For simplicity of implementation, Setex headers are converted to Atx.

-   `:HeaderIncrease`: Analogous to `:HeaderDecrease`, but increase levels instead.

-   `:SetexToAtx`:

    Convert all Setex style headers in buffer to Atx.

    If a range is given, e.g. hit `:` from visual mode, only operate on the range.

-   `:TableFormat`: Format the table under the cursor [like this](http://www.cirosantilli.com/markdown-style-guide/#tables).

    Requires [Tabular](https://github.com/godlygeek/tabular).

    The input table *must* already have a separator line as the second line of the table.
    That line only needs to contain the correct pipes `|`, nothing else is required.

-   `:Toc`: create a quickfix vertical window navigable table of contents with the headers.

    Hit `<Enter>` on a line to jump to the corresponding line of the markdown file.

-   `:Toch`: Same as `:Toc` but in an horizontal window.

-   `:Toct`: Same as `:Toc` but in a new tab.

-   `:Tocv`: Same as `:Toc` for symmetry with `:Toch` and `:Tocv`.

-   `:InsertToc`: Insert table of contents at the current line.

    An optional argument can be used to specify how many levels of headers to display in the table of content, e.g., to display up to and including `h3`, use `:InsertToc 3`.

-   `:InsertNToc`: Same as `:InsertToc`, but the format of `h2` headers in the table of contents is a numbered list, rather than a bulleted list.

### Credits

The main contributors of vim-markdown are:

- **Ben Williams** (A.K.A. **plasticboy**). The original developer of vim-markdown. [Homepage](http://plasticboy.com/).

If you feel that your name should be on this list, please make a pull request listing your contributions.

### License

The MIT License (MIT)

Copyright (c) 2012 Benjamin D. Williams

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
