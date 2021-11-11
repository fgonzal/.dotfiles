set sm
set ai
set number
syntax on
set hidden
let java_highlight_all=1
let java_highlight_functions="style"
let java_allow_cpp_keywords=1
set complete=.,w,b,u,t,i
set ts=8
set sts=4
set sw=4
set expandtab

set backupdir=~/.config/nvim/backup//
set directory=~/.config/nvim/swap//
set undodir=~/.config/nvim/undo//

" Make sure vim-plug is installed.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/plugged')

Plug 'neovim/nvim-lspconfig'
" Fuzzy finder.
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Syntax highlight.
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  
Plug 'preservim/nerdtree'
" Stable version of coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

set termguicolors
color dracula

"autocmd vimenter * ++nested colorscheme gruvbox

" No more :update or :w to save files.
nnoremap zz :update<CR>

" Quick access to fuzzy finder.
nnoremap <silent> <C-f> :FZF<CR>

" Status bar
set laststatus=2
set statusline=

map <C-n> :NERDTreeToggle<CR>

nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>= <Plug>AirlineSelectNextTab

let g:airline#extensions#tabline#enabled = 1

" Show a '+' next to file names in the statusline for modified buffers.
let g:airline_detect_modified = 0 "if you're sticking the + in section_c you probably want to disable detection
function! Init()
  call airline#parts#define_raw('modified', '%{&modified ? "+" : ""}')
  call airline#parts#define_accent('modified', 'red')
  let g:airline_section_c = airline#section#create(['%t', 'modified'])
endfunction
autocmd VimEnter * call Init()

" External files.
source $HOME/.config/nvim/plug-config/coc.vim
