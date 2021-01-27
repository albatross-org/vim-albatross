" Vim syntax file
" Language:	Markdown
" Maintainer:	Ben Williams <benw@plasticboy.com>
" URL:		http://plasticboy.com/markdown-vim-mode/
" Remark:	Uses HTML syntax file
" TODO: 	Handle stuff contained within stuff (e.g. headings within blockquotes)


" Read the HTML syntax to start with
if version < 600
  so <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim

  if exists('b:current_syntax')
    unlet b:current_syntax
  endif
endif

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" don't use standard HiLink, it will not work with included syntax files
if version < 508
  command! -nargs=+ HtmlHiLink hi link <args>
else
  command! -nargs=+ HtmlHiLink hi def link <args>
endif

syn spell toplevel
syn case ignore
syn sync linebreaks=1

let s:conceal = ''
let s:concealends = ''
let s:concealcode = ''
if has('conceal') && get(g:, 'vim_markdown_conceal', 1)
  let s:conceal = ' conceal'
  let s:concealends = ' concealends'
endif
if has('conceal') && get(g:, 'vim_markdown_conceal_code_blocks', 1)
  let s:concealcode = ' concealends'
endif

" additions to HTML groups
if get(g:, 'vim_markdown_emphasis_multiline', 1)
    let s:oneline = ''
else
    let s:oneline = ' oneline'
endif
syn region mkdItalic matchgroup=mkdItalic start="\%(\*\|_\)"    end="\%(\*\|_\)"
syn region mkdBold matchgroup=mkdBold start="\%(\*\*\|__\)"    end="\%(\*\*\|__\)"
syn region mkdBoldItalic matchgroup=mkdBoldItalic start="\%(\*\*\*\|___\)"    end="\%(\*\*\*\|___\)"
execute 'syn region htmlItalic matchgroup=mkdItalic start="\%(^\|\s\)\zs\*\ze[^\\\*\t ]\%(\%([^*]\|\\\*\|\n\)*[^\\\*\t ]\)\?\*\_W" end="[^\\\*\t ]\zs\*\ze\_W" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlItalic matchgroup=mkdItalic start="\%(^\|\s\)\zs_\ze[^\\_\t ]" end="[^\\_\t ]\zs_\ze\_W" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBold matchgroup=mkdBold start="\%(^\|\s\)\zs\*\*\ze\S" end="\S\zs\*\*" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBold matchgroup=mkdBold start="\%(^\|\s\)\zs__\ze\S" end="\S\zs__" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBoldItalic matchgroup=mkdBoldItalic start="\%(^\|\s\)\zs\*\*\*\ze\S" end="\S\zs\*\*\*" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBoldItalic matchgroup=mkdBoldItalic start="\%(^\|\s\)\zs___\ze\S" end="\S\zs___" keepend contains=@Spell' . s:oneline . s:concealends

" [link](URL) | [link][id] | [link][] | ![image](URL)
syn region mkdFootnotes matchgroup=mkdDelimiter start="\[^"    end="\]"
execute 'syn region mkdID matchgroup=mkdDelimiter    start="\["    end="\]" contained oneline' . s:conceal
execute 'syn region mkdURL matchgroup=mkdDelimiter   start="("     end=")"  contained oneline' . s:conceal
execute 'syn region mkdLink matchgroup=mkdDelimiter  start="\\\@<!!\?\[\ze[^]\n]*\n\?[^]\n]*\][[(]" end="\]" contains=@mkdNonListItem,@Spell nextgroup=mkdURL,mkdID skipwhite' . s:concealends

" Autolink without angle brackets.
" mkd  inline links:      protocol     optional  user:pass@  sub/domain                    .com, .co.uk, etc         optional port   path/querystring/hash fragment
"                         ------------ _____________________ ----------------------------- _________________________ ----------------- __
syn match   mkdInlineURL /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*/

" Autolink with parenthesis.
syn region  mkdInlineURL matchgroup=mkdDelimiter start="(\(https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*)\)\@=" end=")"

" Autolink with angle brackets.
syn region mkdInlineURL matchgroup=mkdDelimiter start="\\\@<!<\ze[a-z][a-z0-9,.-]\{1,22}:\/\/[^> ]*>" end=">"

" Link definitions: [id]: URL (Optional Title)
syn region mkdLinkDef matchgroup=mkdDelimiter   start="^ \{,3}\zs\[\^\@!" end="]:" oneline nextgroup=mkdLinkDefTarget skipwhite
syn region mkdLinkDefTarget start="<\?\zs\S" excludenl end="\ze[>[:space:]\n]"   contained nextgroup=mkdLinkTitle,mkdLinkDef skipwhite skipnl oneline
syn region mkdLinkTitle matchgroup=mkdDelimiter start=+"+     end=+"+  contained
syn region mkdLinkTitle matchgroup=mkdDelimiter start=+'+     end=+'+  contained
syn region mkdLinkTitle matchgroup=mkdDelimiter start=+(+     end=+)+  contained

"HTML headings
syn region htmlH1       matchgroup=mkdHeading     start="^\s*#"                   end="$" contains=mkdLink,mkdInlineURL,@Spell
syn region htmlH2       matchgroup=mkdHeading     start="^\s*##"                  end="$" contains=mkdLink,mkdInlineURL,@Spell
syn region htmlH3       matchgroup=mkdHeading     start="^\s*###"                 end="$" contains=mkdLink,mkdInlineURL,@Spell
syn region htmlH4       matchgroup=mkdHeading     start="^\s*####"                end="$" contains=mkdLink,mkdInlineURL,@Spell
syn region htmlH5       matchgroup=mkdHeading     start="^\s*#####"               end="$" contains=mkdLink,mkdInlineURL,@Spell
syn region htmlH6       matchgroup=mkdHeading     start="^\s*######"              end="$" contains=mkdLink,mkdInlineURL,@Spell
syn match  htmlH1       /^.\+\n=\+$/ contains=mkdLink,mkdInlineURL,@Spell
syn match  htmlH2       /^.\+\n-\+$/ contains=mkdLink,mkdInlineURL,@Spell

"define Markdown groups
syn match  mkdLineBreak    /  \+$/
syn region mkdBlockquote   start=/^\s*>/                   end=/$/ contains=mkdLink,mkdInlineURL,mkdLineBreak,@Spell
execute 'syn region mkdCode matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!`/                     end=/`/'  . s:concealcode
execute 'syn region mkdCode matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!``/ skip=/[^`]`[^`]/   end=/``/' . s:concealcode
execute 'syn region mkdCode matchgroup=mkdCodeDelimiter start=/^\s*\z(`\{3,}\)[^`]*$/                       end=/^\s*\z1`*\s*$/'            . s:concealcode
execute 'syn region mkdCode matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!\~\~/  end=/\(\([^\\]\|^\)\\\)\@<!\~\~/'               . s:concealcode
execute 'syn region mkdCode matchgroup=mkdCodeDelimiter start=/^\s*\z(\~\{3,}\)\s*[0-9A-Za-z_+-]*\s*$/      end=/^\s*\z1\~*\s*$/'           . s:concealcode
execute 'syn region mkdCode matchgroup=mkdCodeDelimiter start="<pre\(\|\_s[^>]*\)\\\@<!>"                   end="</pre>"'                   . s:concealcode
execute 'syn region mkdCode matchgroup=mkdCodeDelimiter start="<code\(\|\_s[^>]*\)\\\@<!>"                  end="</code>"'                  . s:concealcode
syn region mkdFootnote     start="\[^"                     end="\]"
syn match  mkdCode         /^\s*\n\(\(\s\{8,}[^ ]\|\t\t\+[^\t]\).*\n\)\+/
syn match  mkdCode         /\%^\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/
syn match  mkdCode         /^\s*\n\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/ contained
syn match  mkdListItem     /^\s*\%([-*+]\|\d\+\.\)\ze\s\+/ contained
syn region mkdListItemLine start="^\s*\%([-*+]\|\d\+\.\)\s\+" end="$" oneline contains=@mkdNonListItem,mkdListItem,@Spell
syn region mkdNonListItemBlock start="\(\%^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@!\|\n\(\_^\_$\|\s\{4,}[^ ]\|\t+[^\t]\)\@!\)" end="^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@=" contains=@mkdNonListItem,@Spell
syn match  mkdRule         /^\s*\*\s\{0,1}\*\s\{0,1}\*\(\*\|\s\)*$/
syn match  mkdRule         /^\s*-\s\{0,1}-\s\{0,1}-\(-\|\s\)*$/
syn match  mkdRule         /^\s*_\s\{0,1}_\s\{0,1}_\(_\|\s\)*$/

" ---------------------------
" Albatross Stuff starts here
" ---------------------------

" I've spent a while trying to figure this out and I think I've got it. I was confused as to why something like
"
"  syntax keyword albatrossLink legumes
"  highlight link albatrossLink Statement
"
" Wouldn't work. I'm pretty sure vim-markdown (understandably) has some pretty wide-reaching syntax rules like the one for mkdNonListItemBlock,
" so as long as that matches, the specific syntax that I describe here won't work. Therefore, for any syntax rules to play nicely with vim-markdown
" means the syntax groups also need to be in the @mkdNonListItem cluster which is in "contains=" stuff like mkdNonListItemBlock.
"
" To get around this problem, I've defined a new syntax cluster which contains all the custom Albatross rules. This is then added once to the
" @mkdNonListItem. This is probably very poorly explained -- I barely understand it myself.

" Links
" -----

" Plain links:
" Link by title, e.g. "[[Pizza]]"
syntax region albatrossLinkNoName start=/\[\[/ end=/\]\]/ oneline
highlight link albatrossLinkNoName htmlLink

" Link by path, e.g. "{{food/pizza}}"
syntax region albatrossLinkPathNoName start=/{{/ end=/}}/ oneline
highlight link albatrossLinkPathNoName htmlLink

" Links with names:
" Link by title with name, e.g. "[[Pizza](Alternate name)]"
syntax region albatrossLinkWithNameEntry matchgroup=albatrossLinkWithName start=/\[/ end=/\]/ oneline contained containedin=albatrossLinkWithName
syntax region albatrossLinkWithNameTitle matchgroup=albatrossLinkWithName start="(" end=")" oneline contained containedin=albatrossLinkWithName
syntax region albatrossLinkWithName start=/\[/ end=/)\]/ oneline keepend contains=albatrossLinkWithNameEntry,albatrossLinkWithName

highlight link albatrossLinkWithNameEntry Underlined
highlight link albatrossLinkWithNameTitle Underlined
highlight link albatrossLinkWithName Underlined

" Link by path with name, e.g. "{{food/pizza}(Pizza)}"
syntax region albatrossLinkPathWithNameEntry matchgroup=albatrossLinkPathWithName start=/{/ end=/}/ oneline contained containedin=albatrossLinkPathWithName
syntax region albatrossLinkPathWithNameTitle matchgroup=albatrossLinkPathWithName start="(" end=")" oneline contained containedin=albatrossLinkPathWithName
syntax region albatrossLinkPathWithName start=/{/ end=/)}/ oneline keepend contains=albatrossLinkPathWithNameEntry,albatrossLinkPathWithNameTitle

highlight link albatrossLinkPathWithNameEntry Underlined
highlight link albatrossLinkPathWithNameTitle Underlined
highlight link albatrossLinkPathWithName Underlined

" Having some trouble with the links with names. How it should be parsed:
"
" {{food/pizza}(Pizza)}   or  [[Pizza](Alternative name)]
" |^^^^^^^^^^^ ^^^^^^^|
" |      |        |   |
" |    entry      |   |
" |             title |
" |                   |
" \-----withName------/
"
" How it is actually being parsed:
"
" {{food/pizza}(Pizza)}   or  [[Pizza](Alternative name)]
" |^^^^^^^^^^^| ^^^^^ |
" |      |    |    |  |
" |    entry  |    |  |
" |           |  title|
" |           |       |
" \-----withName------/
"
" The difference is kind of hard to see in such a rubbish diagram. Basically, the second "{" is being matched correctly as the entry
" as it should, but the final one still belongs to the overall link. For the title, both brackets "(" and ")" are being highlighted as
" part of the overall link whereas they should be highlighted like the title.
" Since at the moment it's purely cosmetic, it can be solved by setting all the regions to the same highlighting group like so:
"
"  highlight link albatrossLinkPathWithNameEntry Underlined
"  highlight link albatrossLinkPathWithNameTitle Underlined
"  highlight link albatrossLinkPathWithName Underlined
"
" But to easily see the problem, it's better to set them to three different highlighting groups:
"
"  highlight link albatrossLinkPathWithNameEntry Type
"  highlight link albatrossLinkPathWithNameTitle Statement
"  highlight link albatrossLinkPathWithName Error

syntax cluster albatrossLinks contains=albatrossLinkNoName,albatrossLinkWithName,albatrossLinkPathNoName,albatrossLinkPathWithName

" Tags
" -----

syntax match albatrossBuiltinTag /@!\S\+/
syntax match albatrossCustomTag /@?\S\+/

highlight link albatrossBuiltinTag Type
highlight link albatrossCustomTag Type

syntax cluster albatrossTags contains=albatrossBuiltinTag,albatrossCustomTag

" Finally...
" ---------

" This cluster is appended to the mkdNonListItem later on.
syntax cluster albatrossSyntax contains=@albatrossLinks,@albatrossTags

" ---------------------------
" Albatross Stuff ends here
" ---------------------------

" YAML frontmatter
if get(g:, 'vim_markdown_frontmatter', 0)
  syn include @yamlTop syntax/yaml.vim
  syn region Comment matchgroup=mkdDelimiter start="\%^---$" end="^\(---\|\.\.\.\)$" contains=@yamlTop keepend
  unlet! b:current_syntax
endif

if get(g:, 'vim_markdown_toml_frontmatter', 0)
  try
    syn include @tomlTop syntax/toml.vim
    syn region Comment matchgroup=mkdDelimiter start="\%^+++$" end="^+++$" transparent contains=@tomlTop keepend
    unlet! b:current_syntax
  catch /E484/
    syn region Comment matchgroup=mkdDelimiter start="\%^+++$" end="^+++$"
  endtry
endif

if get(g:, 'vim_markdown_json_frontmatter', 0)
  try
    syn include @jsonTop syntax/json.vim
    syn region Comment matchgroup=mkdDelimiter start="\%^{$" end="^}$" contains=@jsonTop keepend
    unlet! b:current_syntax
  catch /E484/
    syn region Comment matchgroup=mkdDelimiter start="\%^{$" end="^}$"
  endtry
endif

if get(g:, 'vim_markdown_math', 0)
  syn include @tex syntax/tex.vim
  syn region mkdMath start="\\\@<!\$" end="\$" skip="\\\$" contains=@tex keepend
  syn region mkdMath start="\\\@<!\$\$" end="\$\$" skip="\\\$" contains=@tex keepend
endif

" Strike through
if get(g:, 'vim_markdown_strikethrough', 0)
    execute 'syn region mkdStrike matchgroup=htmlStrike start="\%(\~\~\)" end="\%(\~\~\)"' . s:concealends
    HtmlHiLink mkdStrike        htmlStrike
endif

" Albatross: Note the addition of the @albatrossSyntax cluster at the end.
syn cluster mkdNonListItem contains=@htmlTop,htmlItalic,htmlBold,htmlBoldItalic,mkdFootnotes,mkdInlineURL,mkdLink,mkdLinkDef,mkdLineBreak,mkdBlockquote,mkdCode,mkdRule,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,mkdMath,mkdStrike,@albatrossSyntax
" Original:
" syn cluster mkdNonListItem contains=@htmlTop,htmlItalic,htmlBold,htmlBoldItalic,mkdFootnotes,mkdInlineURL,mkdLink,mkdLinkDef,mkdLineBreak,mkdBlockquote,mkdCode,mkdRule,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,mkdMath,mkdStrike

"highlighting for Markdown groups
HtmlHiLink mkdString        String
HtmlHiLink mkdCode          String
HtmlHiLink mkdCodeDelimiter String
HtmlHiLink mkdCodeStart     String
HtmlHiLink mkdCodeEnd       String
HtmlHiLink mkdFootnote      Comment
HtmlHiLink mkdBlockquote    Comment
HtmlHiLink mkdListItem      Identifier
HtmlHiLink mkdRule          Identifier
HtmlHiLink mkdLineBreak     Visual
HtmlHiLink mkdFootnotes     htmlLink
HtmlHiLink mkdLink          htmlLink
HtmlHiLink mkdURL           htmlString
HtmlHiLink mkdInlineURL     htmlLink
HtmlHiLink mkdID            Identifier
HtmlHiLink mkdLinkDef       mkdID
HtmlHiLink mkdLinkDefTarget mkdURL
HtmlHiLink mkdLinkTitle     htmlString
HtmlHiLink mkdDelimiter     Delimiter

let b:current_syntax = "mkd"

delcommand HtmlHiLink
" vim: ts=8
