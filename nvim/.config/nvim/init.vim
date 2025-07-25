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
set sw=4
set sts=4
set expandtab
set ttyfast                 " Speed up scrolling in Vim
set mouse=a                 " enable mouse click
set cursorline              " highlight current cursorline
set cc=100                  " set an 100 column border for good coding style
set linespace=3
set wildmode=longest,list,full
set wildmenu
set scrolloff=10

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

" Change the direction of new splits.
" set splitbelow
set splitright

set clipboard=unnamedplus
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
Plug 'nvim-treesitter/playground'
Plug 'preservim/nerdtree'

" Stable version of coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-snippets'
Plug 'tpope/vim-fugitive'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-rhubarb'

" Themes
" Plug 'joshdick/onedark.vim'
" Plug 'gruvbox-community/gruvbox'
" Plug 'luisiacc/gruvbox-baby'
" Plug 'luisiacc/gruvbox-baby', {'branch': 'main'}
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
" Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
" Plug 'rose-pine/neovim', { 'as': 'rosepine' }
" Plug 'Shatur/neovim-ayu', { 'as': 'ayu' }
" Plug 'folke/tokyonight.nvim'
" Plug 'Mofiqul/dracula.nvim'

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'fannheyward/telescope-coc.nvim'

" Harpoon
"Plug 'nvim-lua/plenary.nvim' " don't forget to add this one if you don't have it yet!
Plug 'ThePrimeagen/harpoon'

" Unit tests!
Plug 'vim-test/vim-test'

" Codeium
" Plug 'Exafunction/codeium.vim', { 'branch': 'main' }

call plug#end()

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

command Formatxml silent %!xmllint --encode UTF-8 --format -

set termguicolors
" color dracula
" colorscheme onedark
" colorscheme gruvbox
" colorscheme duskfox
" colorscheme gruvbox-baby
" colorscheme tokyonight
" nnoremap <silent> <C-f> :FZF<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>fp <cmd>Telescope git_files<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
" nnoremap <leader>fg <cmd>Telescope live_grep glob_pattern=!*{log*,gz,_r,_s}<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fo <cmd>Telescope coc document_symbols<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nmap <silent> <leader>tt :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
" nmap <silent> <leader>g :TestVisit<CR>

" Harpoon.
nnoremap <silent><leader>ha :lua require("harpoon.mark").add_file()<CR>
nnoremap <silent><leader>hs :lua require("harpoon.ui").toggle_quick_menu()<CR>

nnoremap <silent><leader>1 :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <silent><leader>2 :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <silent><leader>3 :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <silent><leader>4 :lua require("harpoon.ui").nav_file(4)<CR>

noremap <c-s-up> :m -2<CR>  
noremap <c-s-down> :m +1<CR> 

" reselect pasted text
nnoremap gp `[v`]

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

map <C-n> :NERDTreeToggle<CR>

" autocmd vimenter * ++nested colorscheme gruvbox
autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE

" Do not show line numbers in terminal mode.
autocmd TermOpen * setlocal nonumber norelativenumber

highlight Normal     ctermbg=NONE guibg=NONE
highlight LineNr     ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE

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
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
" inoremap <c-j> <Esc>:m .+1<CR>==gi
" inoremap <c-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Center screen when looping through search results.
cnoremap <expr> <CR> getcmdtype() =~ '[/?]' ? '<CR>zz' : '<CR>'
nnoremap n nzzzv
nnoremap N Nzzzv

" Center screen when scrolling full pages.
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

inoremap <C-c> <Esc>

lua << EOF
---[[
-- require("catppuccin").setup {
--     -- flavour = "macchiato" -- mocha, macchiato, frappe, latte
--     flavour = "mocha",
--     no_italic = true,
--     color_overrides = {
--         mocha = {
--             base = "#000000",
--         }
--     },
--     integrations = {
--         telescope = {
--             enabled = true,
--             -- style = "nvchad"
--         },
--         nvimtree = true,
--         treesitter = true, 
--         harpoon = true
--     },
--     custom_highlights = {
--         NvimTreeNormal = { bg = "NONE" },
--     }
-- }
--]]
-- require('rose-pine').setup({
--                 disable_background = true,
--                 styles = {
--                     italic = false,
--                 },
--             })
-- require('dracula').setup({
--                 transparent_bg = true,
--             })
require("tokyonight").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
  transparent = false, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = false },
    keywords = { italic = false },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
  sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors)
    colors.bg = "#000000"
  end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors) end,
})
require("nvim-treesitter.configs").setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
}
EOF

" colorscheme catppuccin
" colorscheme rose-pine
colorscheme tokyonight-night
" colorscheme dracula-soft

highlight WinSeparator guibg=None 
highlight ColorColumn ctermbg=0 guibg=#080808

highlight Conditional cterm=NONE gui=NONE guifg=#cba6f7 
highlight Comment cterm=NONE gui=NONE guifg=#585b70 

set background=dark

lua << EOF
local function status_line()
  local mode = " %-5{%v:lua.string.upper(v:lua.vim.fn.mode())%}"
  local file_name = "%-.25t"
  local modified = " %-m"
  local coc = "%30{coc#status()}"
  local file_type = " %y"
  local right_align = "%="
  local line_no = "%13(%c:%l/%L%) "

  return string.format(
    "%s%s%s%s%s%s%s",
    mode,
    file_name,
    modified,
    coc,
    right_align,
    file_type,
    line_no
  )
end

require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      n = {
    	  ['<c-d>'] = require('telescope.actions').delete_buffer
      }, -- n
      i = {
        ["<C-h>"] = "which_key",
        ['<c-d>'] = require('telescope.actions').delete_buffer
      } -- i
    }, -- mappings
    preview = {
      hide_on_startup = true -- hide previewer when picker starts
    },
    extensions = {
      coc = {
          theme = 'ivy',
          prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
          push_cursor_on_edit = true, -- save the cursor position to jump back in the future
          timeout = 3000, -- timeout for coc commands
      }
    },
  }, -- defaults
...
} -- telescope setup

vim.opt.statusline = status_line()
EOF
