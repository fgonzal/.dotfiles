set sm
set ai
set relativenumber
set nu
set rnu
syntax on
set hidden
let java_highlight_all=1
let java_highlight_functions="style"
let java_allow_cpp_keywords=1
set complete=.,w,b,u,t,i
set ts=4
set sts=4
set sw=4
set expandtab
set ttyfast                 " Speed up scrolling in Vim
set cursorline
set mouse=a                 " enable mouse click
set cursorline              " highlight current cursorline
set cc=100                  " set an 100 column border for good coding style
set linespace=3
set wildmode=longest,list,full
set wildmenu
" Ignore files
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/.git/*

set backupdir=~/.config/nvim/backup//
set directory=~/.config/nvim/swap//
set undodir=~/.config/nvim/undo//

" Use smartcase when searching within a file.
set ignorecase
set smartcase
set incsearch

set clipboard=unnamedplus
set background=dark
nnoremap <SPACE> <Nop>
let mapleader = " "

" Make sure vim-plug is installed.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/plugged')

Plug 'neovim/nvim-lspconfig'
" Fuzzy finder.
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'
" Syntax highlight.
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  
Plug 'preservim/nerdtree'

" Stable version of coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-snippets'
Plug 'tpope/vim-fugitive'
Plug 'tomtom/tcomment_vim'

" Themes
" Plug 'joshdick/onedark.vim'
" Plug 'gruvbox-community/gruvbox'
" Plug 'luisiacc/gruvbox-baby'
" Plug 'luisiacc/gruvbox-baby', {'branch': 'main'}
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Harpoon
"Plug 'nvim-lua/plenary.nvim' " don't forget to add this one if you don't have it yet!
Plug 'ThePrimeagen/harpoon'

" Unit tests!
Plug 'vim-test/vim-test'

call plug#end()

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

set termguicolors
" color dracula
" colorscheme onedark
" colorscheme gruvbox
" colorscheme duskfox
" colorscheme gruvbox-baby
colorscheme tokyonight

" Quick access to fuzzy finder.
" nnoremap <silent> <C-f> :FZF<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Harpoon.
nnoremap <silent><leader>ha :lua require("harpoon.mark").add_file()<CR>
nnoremap <silent><leader>hs :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <silent><leader>hu :lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>

nnoremap <silent><leader>u :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <silent><leader>i :lua require("harpoon.ui").nav_file(2)<CR>
" nnoremap <silent><leader>o :lua require("harpoon.ui").nav_file(3)<CR>
" nnoremap <silent><leader>p :lua require("harpoon.ui").nav_file(4)<CR>

noremap <c-s-up> :m -2<CR>  
noremap <c-s-down> :m +1<CR> 

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Status bar
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=%#PmenuSel#
"set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %f
"set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

map <C-n> :NERDTreeToggle<CR>


" autocmd vimenter * ++nested colorscheme gruvbox
autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE
highlight Normal     ctermbg=NONE guibg=NONE
highlight LineNr     ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE

nnoremap <leader>lg :lua require('telescope.builtin').live_grep()<CR>

" External files.
source $HOME/.config/nvim/plug-config/coc.vim

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"
" remap for complete to use tab and <cr>
" inoremap <silent><expr> <TAB>
"             \ coc#pum#visible() ? coc#pum#next(1):
"             \ <SID>check_back_space() ? "\<Tab>" :
"             \ coc#refresh()
" inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()

hi CocSearch ctermfg=12 guifg=#18A3FF
hi CocMenuSel ctermbg=109 guibg=#13354A

" Remaps to move lines around.
nnoremap <c-j> :m .+1<CR>==
nnoremap <c-k> :m .-2<CR>==
" inoremap <c-j> <Esc>:m .+1<CR>==gi
" inoremap <c-k> <Esc>:m .-2<CR>==gi
vnoremap <c-j> :m '>+1<CR>gv=gv
vnoremap <c-k> :m '<-2<CR>gv=gv
