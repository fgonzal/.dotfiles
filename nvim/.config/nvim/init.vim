set sm
set ai
set number
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
Plug 'tpope/vim-fugitive'
Plug 'dracula/vim', { 'as': 'dracula' }
" #Plug 'vim-airline/vim-airline'
" #Plug 'vim-airline/vim-airline-themes'
Plug 'tomtom/tcomment_vim'

" Themes
" Plug 'joshdick/onedark.vim'
Plug 'gruvbox-community/gruvbox'
Plug 'luisiacc/gruvbox-baby'

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Harpoon
Plug 'nvim-lua/plenary.nvim' " don't forget to add this one if you don't have it yet!
Plug 'ThePrimeagen/harpoon'
call plug#end()

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

set termguicolors
" color dracula
" colorscheme onedark
colorscheme gruvbox

" Quick access to fuzzy finder.
" nnoremap <silent> <C-f> :FZF<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <silent><leader>ha :lua require("harpoon.mark").add_file()<CR>
nnoremap <silent><leader>hs :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <silent><leader>hu :lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>

nnoremap <silent><leader>u :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <silent><leader>i :lua require("harpoon.ui").nav_file(2)<CR>
" nnoremap <silent><leader>o :lua require("harpoon.ui").nav_file(3)<CR>
" nnoremap <silent><leader>p :lua require("harpoon.ui").nav_file(4)<CR>

" Status bar
set laststatus=2
" set statusline=%f
set stl+=%{expand('%:~:.')}

map <C-n> :NERDTreeToggle<CR>

nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>= <Plug>AirlineSelectNextTab

autocmd vimenter * ++nested colorscheme gruvbox
autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE
highlight Normal     ctermbg=NONE guibg=NONE
highlight LineNr     ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE
" let g:airline#extensions#tabline#enabled = 1

" Show a '+' next to file names in the statusline for modified buffers.
" let g:airline_detect_modified = 0 "if you're sticking the + in section_c you probably want to disable detection
" function! Init()
"   call airline#parts#define_raw('modified', '%{&modified ? "+" : ""}')
"   call airline#parts#define_accent('modified', 'red')
"   let g:airline_section_c = airline#section#create(['%t', 'modified'])
" endfunction
" autocmd VimEnter * call Init()

" External files.
source $HOME/.config/nvim/plug-config/coc.vim
