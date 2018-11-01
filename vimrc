call plug#begin()

" LSP for neovim
Plug 'autozimu/LanguageClient-neovim', {
\ 'branch': 'next',
\ 'do': 'bash install.sh',
\ }

" Multi-entry selection UI.
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"Plug 'junegunn/fzf.vim'

" Nice status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Show git diff visually
" Or https://github.com/airblade/vim-gitgutter
Plug 'mhinz/vim-signify'

" Git wrapper (and access to git-grep)
Plug 'tpope/vim-fugitive'

" Completion plugin
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Completion setup.
"call deoplete#enable()
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

"let g:deoplete#enable_at_startup = 1
"if !exists('g:deoplete#omni#input_patterns')
"    let g:deoplete#omni#input_patterns = {}
"endif
""let g:deoplete#disable_auto_complete = 1
"autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-ultisnips'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANTE: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" NOTE: you need to install completion sources to get completions. Check
" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-tmux'
Plug 'ncm2/ncm2-path'
" suppress the annoying 'match x of y', 'The only match' and 'Pattern not
" found' messages
set shortmess+=c

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" wrap existing omnifunc
" Note that omnifunc does not run in background and may probably block the
" editor. If you don't want to be blocked by omnifunc too often, you could
" add 180ms delay before the omni wrapper:
"  'on_complete': ['ncm2#on_complete#delay', 180,
"               \ 'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
au User Ncm2Plugin call ncm2#register_source({
  \ 'name' : 'css',
  \ 'priority': 9, 
  \ 'subscope_enable': 1,
  \ 'scope': ['css','scss'],
  \ 'mark': 'css',
  \ 'word_pattern': '[\w\-]+',
  \ 'complete_pattern': ':\s*',
  \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
  \ })

" Press enter key to trigger snippet expansion
" " The parameters are the same as `:help feedkeys()`
inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

" " c-j c-k for moving in snippet
" let g:UltiSnipsExpandTrigger    = "<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger  = "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0


" Asynchronous make calls
Plug 'neomake/neomake'

"Plug 'Shougo/neosnippet.vim'
"Plug 'Shougo/neosnippet-snippets'

" Color schemes
" Plug 'morhetz/gruvbox'
"
" Google color scheme
Plug 'google/vim-colorscheme-primary'

Plug 'altercation/vim-colors-solarized'

" Indent Guide
Plug 'nathanaelkane/vim-indent-guides'

call plug#end()

"syntax enable
"set background=dark
"let g:solarized_termcolors=256
"colorscheme solarized

syntax enable
set t_Co=256
set background=dark
colorscheme primary

let g:indent_guides_enable_on_vim_startup = 1
hi IndentGuidesOdd  ctermbg=white
hi IndentGuidesEven ctermbg=lightgrey



" Color scheme
" set background=dark
" colorscheme gruvbox

" Smarter tabline (see https://github.com/vim-airline/vim-airline)
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme ='dark'



" Configure LSP plugin
let g:LanguageClient_autoStart = 1  
let g:LanguageClient_settingsPath = 'settings.json'
let g:LanguageClient_loadSettings = 1
set completefunc=LanguageClient#complete
set formatexpr=LanguageClient_textDocument_rangeFormatting()
let g:LanguageClient_rootMarkers = {
\ 'cpp': ['main.cpp', 'build', 'compile_commands.json'],
\ }
let g:LanguageClient_setLoggingLevel = 'DEBUG'

" Support for more languages may be added here.
let g:LanguageClient_serverCommands = {
\ 'c': ['ccls', '--log-file=/tmp/cq.log'],
\ 'python': ['pyls'],
\  'javascript': ['javascript-typescript-stdio'],
\ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
\ }

" Required for operations modifying multiple buffers.
set hidden

" Add git information to status line.
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" Shortcuts for LSP
nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" enable mouse clicks
set mouse=a

set makeprg='ninja'
" Make when saving
call neomake#configure#automake('w')


" Use system clipboard
set clipboard=unnamedplus

" Show line numbers
set number

" Set width
set textwidth=100

" Handling tabs
let tabsize=2
execute "set tabstop=".tabsize
execute "set softtabstop=".tabsize
execute "set shiftwidth=".tabsize
set expandtab

filetype plugin on
syntax on


set signcolumn=yes
filetype plugin indent on
set autoindent
set hlsearch

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
augroup ProjectDrawer  
autocmd!  
autocmd VimEnter * :Vexplore
augroup END



