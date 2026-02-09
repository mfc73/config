" My personal preferences (mfc)
" Last changed: 7 Apr 2025

" ---- From tpope/vim-sensible version 2.0 (last retrieved Jan 2025) ----

set nocompatible
set backspace=indent,eol,start
" Disable completing keywords in included files (e.g., #include in C).  When
" configured properly, this can result in the slow, recursive scanning of
" hundreds of files of dubious relevance
set complete-=i
set smarttab
set nrformats-=octal
" Make the escape key more responsive by decreasing the wait time for an
" escape sequence (e.g., arrow keys)
if !has('nvim') && &ttimeoutlen == -1
  set ttimeout ttimeoutlen=100
endif
set incsearch
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
set laststatus=2 ruler
set wildmenu
set scrolloff=1 sidescroll=1 sidescrolloff=2
set display+=truncate
set listchars=tab:⊦–→,trail:–,extends:»,precedes:«,nbsp:+
" Delete comment character when joining commented lines
set formatoptions+=j
" Replace the check for a tags file in the parent directory of the current
" file with a check in every ancestor directory
if has('path_extra') && (',' .. &g:tags .. ',') =~# ',\./tags,'
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif
set autoread
set history=1000
set tabpagemax=50
" Persist g:UPPERCASE variables, used by some plugins, in .viminfo
set viminfo^=!
" Saving options in session and view files causes more problems than it
" solves, so disable it.
set sessionoptions-=options
set viewoptions-=options
" Allow color schemes to do bright colors without forcing bold
if &t_Co == 8
  set t_Co=16
endif
set nolangremap
filetype plugin indent on
syntax enable
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>pumvisib
if exists(":DiffOrig") != 2
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
        \ | diffthis | wincmd p | diffthis
endif
" Correctly highlight $() and other modern affordances in filetype=sh
if !exists('g:is_posix') && !exists('g:is_bash') && !exists('g:is_dash')
  let g:is_posix = 1
endif
" Load matchit.vim, but only if the user hasn't installed a newer version
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif
" Enable the :Man command shipped inside Vim's man filetype plugin.
if exists(':Man') != 2 && !exists('g:loaded_man') && &filetype !=? 'man' && !has('nvim')
  runtime ftplugin/man.vim
  set keywordprg=":Man"
endif

" ---- Quasi-sensible defaults that didn't make it to vim-sensible ----

set synmaxcol=300
set nomodeline
set showcmd
set lazyredraw
set virtualedit+=block
vnoremap > >gv
vnoremap < <gv
noremap Y y$
noremap & <Cmd>&&<CR>
noremap vv V
map Q <Nop>

" ---- Personal preferences ----

" Search
" Apparently, 'ignorecase' looks like a good idea, but it also affects :s, :g,
" *, #, gd, ecc. Better to force case-insensitivity for the current search only
" through "\c", which can be easily deleted if necessary.
noremap / /\c<Left><Left>
noremap ? ?\c<Left><Left>
"set ignorecase smartcase
set tagcase=match hlsearch
nnoremap <Esc><Esc> <Cmd>nohlsearch<CR>

" Tabs
set tabstop=4 softtabstop=4
set shiftwidth=4 shiftround
set expandtab

" cmd-line completion
set wildmode=longest,full wildoptions=pum
set completeopt+=longest
cnoremap <expr> <Esc> pumvisible() ? "<C-E>" : "<C-C>"
cnoremap <expr> <CR>  pumvisible() ? "<C-Y>" : "<CR>"

" 'I' in an empty line obeys autoindent (beware the count!)
nnoremap <expr> I len(getline("."))?"I":"^S<C-\><C-O>" .. v:count1 .. "i"

" SmartHome (via function) ----
function! SmartHomeH(n1, n2)
    let p = col('.')
    exe 'normal! ' .. a:n1
    if col('.') == p
        exe 'normal!' .. a:n2
    endif
endfunction
function! SmartHomeV(n1, n2)
    let p = line('.')
    exe 'normal! ' .. a:n1
    if line('.') == p
        exe 'normal! ' .. a:n2
    endif
endfunction
noremap     <Home> <Cmd>call SmartHomeH('^','0')<CR>
inoremap    <Home> <Cmd>call SmartHomeH('^','0')<CR>
" This looked like a good idea, but didn't stick:
"noremap     <End> <Cmd>call SmartHomeH('g_','$')<CR>
"inoremap    <End> <Cmd>call SmartHomeH('g_','$')<CR>
noremap     <C-Home> <Cmd>call SmartHomeV('H','gg')<CR>
inoremap    <C-Home> <Cmd>call SmartHomeV('H','gg')<CR>
noremap     <C-End> <Cmd>call SmartHomeV('L','G')<CR>
inoremap    <C-End> <Cmd>call SmartHomeV('L','G')<CR>
" Paste from clipboard in insert & command modes -- good idea or not?
noremap! <C-+> <C-R>+
" Use the clipboard in normal mode -- good idea or not?
noremap + "+

" SmartBS (via function) ----
function! SmartBS()
  let x = trim(strpart(getline('.'),0,col('.')-1))
  "if &comments =~ '://' && strpart(getline('.'),0,col('.')-1) =~ '//\s*$'
  if stridx(&comments .. ',' , ':' .. x .. ',') > -1
    "if &comments .. ',' =~ ':' .. trim(strpart(getline('.'),0,col('.')-1)) .. ','
    return "\<C-U>"
  else
    return "\<BS>"
  endif
endfunction
inoremap <BS> <C-R>=SmartBS()<CR>

nnoremap <M-Up>     <Cmd>move .-2<CR>
nnoremap <M-Down>   <Cmd>move .+1<CR>
" Don't use <Cmd> here:
vnoremap <M-Up>     :move '<-2<CR>gv
vnoremap <M-Down>   :move '>+1<CR>gv


" GUI, appearance & colors
set visualbell
set guicursor=a:blinkon0
if has("gui_win32")
    set guifont=Consolas:h10
else
    set guifont=Monospace\ 10
endif
if &term ==# 'win32'
    set background=dark
else
    set termguicolors
    set background=light
endif
set mouse=a
set statusline=%f\ %#Error#%{&mod?'[+]':''}%*%r%h%w%q\ %a%=%{&ft}%{&ff=='unix'?'':'/'.&ff}\ \ '0x%02B'\ %7(↓%l%)\ →%-4c%4p%%
hi clear
hi StatusLineNC guifg=gray25
" correct the crazy defaults for diff-mode
" (copied from GitHub):
hi DiffAdd      guibg=#dafbe1 ctermfg=NONE ctermbg=2
hi DiffDelete   guibg=#ffebe9 ctermfg=NONE ctermbg=4
hi DiffChange   guibg=#ffffaa ctermfg=NONE ctermbg=6
hi DiffText     guibg=#e8ef00 ctermfg=NONE ctermbg=14
" correct the crazy defaults for 'diff' filetype
hi link diffRemoved DiffDelete
hi link diffAdded   DiffAdd
hi diffLine     guibg=#ddf4ff ctermbg=9
hi diffFile     term=bold cterm=bold gui=bold
" ?
" Proposed by Josh Triplett, never accepted in vim-sensible
" Todo: check if it slows down too much
highlight link sensibleWhitespaceError Error
autocmd Syntax * syntax match sensibleWhitespaceError excludenl /\s\+\%#\@<!$\| \+\ze\t/ display containedin=ALL
autocmd Syntax make syntax match sensibleWhitespaceError /^ \+/ display containedin=ALL

" Make :make work with and without a makefile
let prg = 'f() { if [ -r [Mm]akefile ]; then make "$@"; else make "${@:-%:r.exe}"; fi; }; f $*'
if &shell =~# '[bd]ash$'
    let &makeprg = prg
elseif &shell =~? 'cmd.exe$'
    let &makeprg = 'bash -c "' .. substitute(prg, '"', '\\"', 'g') .. '"'
endif
unlet prg
" Old version:
"if &shell =~# '[bd]ash'
"    let &makeprg = '__="$*"; make ${__:-%:r}'
"endif

" ---- C programming ----
" skeleton .h files
function! CreateCHeader()
    let def = substitute(toupper(expand("%:t")), '\W', "_", "g")
    call append(0, "#ifndef " .. def)
    call append(1, "#define " .. def)
    call append(line('$'), "#endif")
endfunction
autocmd BufNewFile *.h call CreateCHeader()

function! CSelfInclude(str)
    if getline('.') ==# a:str
        let cr = (getchar(0) == 13) ? "\<CR>" : ""
        return '#include <' .. a:str .. '.h>' .. cr
    endif
    return a:str
endfunction
function! MyCAbbrev()
    iabbrev <expr> <buffer> assert CSelfInclude("assert")
    iabbrev <expr> <buffer> ctype CSelfInclude("ctype")
    iabbrev <expr> <buffer> stdbool CSelfInclude("stdbool")
    iabbrev <expr> <buffer> stddef CSelfInclude("stddef")
    iabbrev <expr> <buffer> stdint CSelfInclude("stdint")
    iabbrev <expr> <buffer> stdio CSelfInclude("stdio")
    iabbrev <expr> <buffer> stdlib CSelfInclude("stdlib")
    iabbrev <expr> <buffer> string CSelfInclude("string")
    iabbrev <buffer> fori for (int i = 0; i <lt>; ++i)<C-\><C-O>6h
    iabbrev <buffer> #i #include <lt>.h><C-\><C-O>3h<C-R>=getchar(0)?'':''<CR>
    iabbrev <buffer> #I #include ".h"<C-\><C-O>3h<C-R>=getchar(0)?'':''<CR>
endfunction
autocmd FileType c,cpp call MyCAbbrev()
" Add \ in column 78
"noremap <silent> <leader>\ m`<Cmd>s/\s*\\\?\s*$//e<CR>:let xve=&ve\|let &ve='all'\|exe "'[,']norm 78\\|r\\"\|let &ve=xve\|unlet xve\|nohlsearch<CR>``j
noremap <leader>\ :s/^\(.\{-}\)\(\s*\\\)\?$/\=submatch(1)..repeat(' ',77-len(submatch(1)))..'\'/<CR>:noh<CR>j

" ---- Vim programming ----
" execute current row / selection
nnoremap <leader>e yy<Cmd>@"<CR><CR>
vnoremap <leader>e y<Cmd>@"<CR>


finish

" ==== Netrw-specific ====
" see tpope/vinegar
" FIXME: add <buffer> to all mappings!
" FIXME: and put them in an aucommand
let g:netrw_banner = 0
let g:netrw_liststyle = 1
let g:netrw_list_hide = &wildignore
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
# remap ~ to home
nnoremap ~ :edit ~/<CR>
# remap . to : {selectedfile(s)}
fun! EEE(first, last)
    let res = ''
    for i in range(a:first, a:last)
        let bb = getline(i)
        if bb !~ '^" '
            let bb = substitute(bb, '^\(│ \)*', '', '')
            let bb = substitute(bb, '[/*|@=]\=\%([ \t]\{2,}.*\)\=$', "", "")
            let bb = b:netrw_curdir .. '/' .. bb
            let cc = fnamemodify(bb, ':.')
            if substitute(cc, '\', '/', 'g') !=# substitute(bb, '\', '/', 'g')
                let cc = '.' .. (&shellslash ? '/' : '\') .. cc
            endif
            let res = res .. " " .. cc->fnameescape()
        endif
    endfor
    return res
endfun
nnoremap . :<C-U> <C-R>=EEE(line("."), line(".") + v:count1 - 1)<CR><Home>
xnoremap . <Esc>: <C-R>=EEE(line("'<"), line("'>"))<CR><Home>

" ==== /home/mfc/.config/nvim/init.vim ====

" Airline Status Line
"let g:airline_powerline_fonts = 1
"let g:airiline_theme = 'dark'
"let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'
"let g:airline#extensions#wordcount#enabled = 0

" Lightline Status Line
set noshowmode
hi ModCol ctermfg=red
let g:lightline = {
            \ 'colorscheme': 'powerlineish',
            \ 'active': {},
            \ 'inactive': {},
            \ 'component': {},
            \ 'component_function': {},
            \ 'mode_map': {}
            \ }
let g:lightline.active = {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'xfilename', 'xfiletype' ] ],
      \   'right': [ ['percent' ], [ 'lineinfo'],
      \              [ 'charvaluehex' ] ]
      \ }
let g:lightline.inactive = {
            \ 'left': [ [ 'fakemode' ], [ 'filename' ] ],
            \ 'right': [ ]
            \ }
let g:lightline.component = {
      \   'charvaluehex': '0x%02B',
      \   'xfiletype': '%{&ft}%{&ff=="unix"?"":"/".&ff}',
      \   'xfilenamiiiie': '%<%{expand("%:~") .. (&mod?" +":"")}',
      \   'xfilename': '%<%f%{&mod?" +":""}',
      \ }
let g:lightline.component_function = {
      \   'mode': 'LLmode',
      \   'fakemode': 'LLfakemode',
      \   'filename': 'LLfilename',
      \   'lineinfo': 'LLlineinfo'
      \ }

let g:lightline.mode_map = {
      \   'n' : 'Norm',
      \   'i' : 'Ins ',
      \   'R' : 'Repl',
      \   'v' : 'Vis ',
      \   'V' : 'VisL',
      \   "\<C-v>": 'VisB',
      \   'c' : 'Norm',
      \   's' : 'Sel ',
      \   'S' : 'SelL',
      \   "\<C-s>": 'SelB',
      \   't' : 'Term',
      \ }

function! LLlineinfo()
    if winwidth(0) < 80
        let l:fmt = '%d:%d'
    else
        let l:fmt = '%5d:%-3d'
    endif
    return printf(l:fmt, line('.'), col('.')) 
endfunction

function! LLmode()
    if winwidth(0) < 80
        return lightline#mode()[:2]
    endif
    return lightline#mode()
endfunction

function! LLfakemode()
    if winwidth(0) < 80
        return '...'
    endif
    return '....'
endfunction

function! LLfilename()
    let l:maxlen = winwidth(0) / 3
    let l:name = expand('%:~')
    let l:trimmed = len(l:name) > l:maxlen ? '‥' .. l:name[-l:maxlen:] : l:name
    return l:trimmed .. (&mod ? ' +' : '')
endfunction






" ---- learn vimscript the hard way ----


" swap case
inoremap <C-K> <Esc>m`viw~``a
nnoremap <C-K> m`viw~``




" a very very long line with more characters than can be possibly fit into a screenful of GVim unless the 'wrap' option is set

" ==== /home/mfc/.vim/vimrc ====

" My personal preferences (mfc)
"

" taglist
packadd! taglist
let Tlist_Auto_Open = 0
let Tlist_Compact_Format = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Sort_Type = "name"
let Tlist_Use_Right_Window = 1
nnoremap <silent> <F8> :TlistToggle<CR>

packadd! supertab
let g:SuperTabLongestEnhanced = 1

" My Staus Line
"set statusline=%f\ %1*%{&mod?'+':''}%0*%r%h%w%q\ %a%=%{&ft}%{&ff=='unix'?'':'/'.&ff}\ \ '0x%02B'%6l,%-4c%4p%%
"hi User1 guibg=red gui=bold,reverse cterm=reverse
"hi StatusLineNC guifg=gray25

" Airline Status Line
let g:airline_powerline_fonts = 1
let g:airiline_theme = 'dark'
let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'
let g:airline#extensions#wordcount#enabled = 0

" skeleton .h files
au BufNewFile *.h call InsertCHeader()

function! InsertCHeader()
    let def = substitute(toupper(expand("%:t")), '\W', "_", "g")
    call append(0, "#ifndef " .. def)
    call append(1, "#define " .. def)
    "
    call append(line('$'), "#endif")
endfunction

" show assembler version of current file
function! Disaster()
    let l:row = line('.')
    let l:cmd = 'gcc -g -Wa,-adhln -c ' .. expand('%:p') .. ' -o /dev/null'
    let @a = system(cmd)
    new
    setlocal buftype=nofile bufhidden=hide noswapfile
    normal! G
    execute "put a"
    setfiletype asm
    execute '?^\s*' .. l:row .. ':.*' .. expand('%')
    normal! zt
endfunction
" Other version:
" $ gcc -g % -o %:r 
" system ('objdump --demangle --line-numbers -source-comment
" --no-show-raw-insn --disassemble --wide %:r)
" b:output = systemlist('expand -t 4 ' . tmpfile)
" let l:search = expand('%') . ':' . row . '\s*(discriminator \d*)'
" normal! gg
" execute '/' . l:search
" let l:a = line('.')
" normal! G
" execute '?' . l:search
" let l:b = line('.')
" let b:output = b:output[l:a:l:b - 1]
" Now show only b:output e.g in a popup window...
"


" correct the crazy defaults for diff highlighting
hi diffRemoved  ctermfg=1 guifg=Red
hi diffAdded    ctermfg=2 guifg=SeaGreen
hi diffLine     ctermfg=6 guifg=DarkCyan
hi diffFile     term=bold cterm=bold gui=bold

" ---- learn vimscript the hard way ----


" swap case
imap <C-K> <Esc>m`viw~``a
nmap <C-K> m`viw~``

iabbr fori for (int i=0; i <; ++i)<Left><Left><Left><Left><Left><Left>
iabbr #i #include <lt>.h><Left><Left><Left><C-R>=getchar(0)?'':''<CR>
iabbr #I #include ".h"<Left><Left><Left><C-R>=getchar(0)?'':''<CR>

" highlight trailing spaces
nnoremap <leader>w :match Error /\m\s\+$/<CR>
nnoremap <leader>W :match<CR>

" execute current row / selection
nnoremap <leader>e yy:@"<CR>
vnoremap <leader>e y:@"<CR>



" uno   
" due
" tre
" quattro    

" a very very long line with more characters than can be possibly fit into a screenful of GVim unless the 'wrap' option is set

" ==== C:\Users\tzw8bc\AppData\Local\nvim\init.vim ====

" Matteo Cortese, 2022

" GUI
set termguicolors
hi Normal guibg=#f3f3f3 "Gray95
set title
hi LineNr guifg=#737373 guibg=#e6e6e6 "Gray45 on Gray90
"hi CursorLineNr guifg=Gray70 gui=bold
"hi CursorLine guibg=LightYellow
hi diffAdded guibg=#e6ffec
hi diffRemoved guibg=#ffebe9
hi diffFile guifg=blue gui=bold
hi Constant guibg=none
hi Include guifg=#b3b3b3 "Gray70
hi Identifier guifg=none


"investigate whether to recognize numbered lists with set formatoptions+=n


" Searches
" investigate whether to map / to /\v (very-magic!!)
" investigate whether to set 'gdefault'

" Context menu
noremap <silent> <RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent> <RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent> <RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent> <RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv


" Use the new & quick filetype detector in lua
" and skip the old one in vimscript:
"let g:do_filetype_lua = 1
"let g:did_load_filetypes = 0


"investigate whether let mapleader = ","

" <C-T> = prev in tag stack, <C-G> = next in tag stack
noremap <silent> <C-G> :tag<CR>

" Toggle numbers & relative numbers
noremap <silent> <F9> :let [&nu,&rnu] = [1-&nu,1-&nu]<CR>

" The Tab key is under-used, while % is difficult to type
noremap <Tab> %

" The F1 key is often mis-typed when reaching for Esc
noremap  <F1> <Esc>
noremap! <F1> <Esc>

"investigate:
"<leader>cc         toggle line comment
"<leader>c<motion>  comment block of text
"v_<leader>c        comment selection
" c=comment, C=de-comment? or always toggle?

" SnipMate?

function! ScratchOpen1()
    let w = bufwinnr("__Scratch__")
    if w != -1
        execute w .. "wincmd w"
    else
        split __Scratch__
        setlocal buftype=nofile bufhidden=hide noswapfile "buflisted
    endif
endfunction
command! -nargs=0 Scratch call ScratchOpen1()

lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c" },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,
  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },
  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers",
  -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    --disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    --disable = function(lang, buf)
    --    local max_filesize = 100 * 1024 -- 100 KB
    --    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --    if ok and stats and stats.size > max_filesize then
    --        return true
    --    end
    --end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF


