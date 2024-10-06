""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" sudo apt install astyle (format code cpp)
" sudo apt install clangd (for cpp)
" edit CocConfig file using clangd (for cpp)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General settings
autocmd vimEnter *.cpp map <F8> :w <CR> :!clear ; g++ --std=c++17 %; if [ -f a.out ]; then time ./a.out; rm a.out; fi <CR>
set mouse=a                 " Enable mouse
set tabstop=4               " width tab
set shiftwidth=4            " width tab 
set expandtab
set listchars=tab:\¦\       " Tab charactor 
set list
set foldmethod=syntax       " 
set foldnestmax=1
set foldlevelstart=0        "  
set number
set relativenumber                  " Show line number
set ignorecase              " Enable case-sensitive 

"set lcs+=space:·            " enable if want to show space as dot

set guifont=*

noremap <C-f> :%!astyle -s4<CR>  " format c++ code by 1tab = 4 space
" Disable backup
set nobackup
set nowb
set noswapfile

" Quick edit and reload vim config
nmap <leader>ve :edit ~/.config/nvim/init.vim<cr>

" Optimize 
set synmaxcol=200
set lazyredraw
au! BufNewFile,BufRead *.json set foldmethod=indent " Change foldmethod for specific filetype

syntax on

" Enable copying from vim to clipboard
if has('win32')
  set clipboard=unnamed  
else
  set clipboard=unnamedplus
endif

" Auto reload content changed outside
au CursorHold,CursorHoldI * checktime
au FocusGained,BufEnter * :checktime
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
    \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == ''
      \ | checktime 
    \ | endif
autocmd FileChangedShellPost *
    \ echohl WarningMsg 
    \ | echo "File changed on disk. Buffer reloaded."
    \ | echohl None


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Key mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
" Resize pane, note M = Alt
nmap <M-Right> :vertical resize +1<CR>    
nmap <M-Left> :vertical resize -1<CR>
nmap <M-Down> :resize -1<CR>
nmap <M-Up> :resize +1<CR>

" buffer delete, next, previous // leader = \
map <leader>n :bnext<cr>
map <leader>p :bprevious<cr>
map <leader>d :bdelete<cr>
" Search a hightlighted text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
nmap /\ :noh<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin list
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin(stdpath('config').'/plugged')
" Theme
  Plug 'joshdick/onedark.vim',                  " Dark theme

" File browser
  Plug 'preservim/nerdTree'                     " File browser  
"  Plug 'Xuyuanp/nerdtree-git-plugin'            " Git status
  Plug 'ryanoasis/vim-devicons'                 " Icon
  Plug 'tiagofumo'
          \ .'/vim-nerdtree-syntax-highlight'
  Plug 'unkiwii/vim-nerdtree-sync'              " Sync current file 

" File search
 Plug 'junegunn/fzf', 
   \ { 'do': { -> fzf#install() } }            " Fuzzy finder 
 Plug 'junegunn/fzf.vim'
  " pretty
  Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }

" Status bar
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

" Terminal
"  Plug 'voldikss/vim-floaterm'                  " Float terminal

" Code intellisense
  Plug 'neoclide/coc.nvim', 
    \ {'branch': 'release'}                     " Language server protocol (LSP) 
  Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
  Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }
  Plug 'jiangmiao/auto-pairs'                   " Parenthesis auto 
  Plug 'alvan/vim-closetag'
  Plug 'mattn/emmet-vim' 
  Plug 'tpope/vim-commentary'                " Comment code 
  Plug 'liuchengxu/vista.vim'                   " Function tag bar 
  Plug 'alvan/vim-closetag'                     " Auto close HTML/XML tag 
    \ { 
      \ 'do': 'yarn install '
              \ .'--frozen-lockfile '
              \ .'&& yarn build',
      \ 'branch': 'main' 
    \ }

" Code syntax highlight
  Plug 'yuezk/vim-js'                           " Javascript
  " Plug 'MaxMEllon/vim-jsx-pretty'               " JSX/React
  Plug 'jackguo380/vim-lsp-cxx-highlight'       " C/C++
"  Plug 'uiiaoo/java-syntax.vim'                 " Java

" show indent line 
  Plug 'lukas-reineke/indent-blankline.nvim'
" treesitter   - it support for indent to hightlight block is activate
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Debugging
"  Plug 'puremourning/vimspector'                " Vimspector

" Source code version control 
"  Plug 'tpope/vim-fugitive'                     " Git infomation 
"  Plug 'tpope/vim-rhubarb' 
"  Plug 'airblade/vim-gitgutter'                 " Git show changes 
"  Plug 'samoshkin/vim-mergetool'                " Git merge

" VERILOG
    Plug 'vhda/verilog_systemverilog.vim'
call plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set theme 
colorscheme onedark

" Overwrite some color highlight 
if (has("autocmd"))
  augroup colorextend
    autocmd ColorScheme 
      \ * call onedark#extend_highlight("Comment",{"fg": {"gui": "#728083"}})
    autocmd ColorScheme 
      \ * call onedark#extend_highlight("LineNr", {"fg": {"gui": "#728083"}})
  augroup END
endif

" Disable automatic comment in newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" use <tab> for trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" nerttree config
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-m> :NERDTreeToggle<CR>
" config for ejs
au BufNewFile,BufRead *.ejs set filetype=html
" conpile c/c++ file
"nnoremap <f6> <esc>:!gcc -o %:r %:t<enter>
nnoremap <f7> <esc>:!g++ -std=c++14 -o %:r %:t<enter>
nnoremap <f8> <esc>:!./%:r<enter>

" Other setting
for setting_file in split(glob(stdpath('config').'/settings/*.vim'))
  execute 'source' setting_file
endfor

for setting_file in split(glob(stdpath('config').'/settings/*.lua'))
  execute 'source' setting_file
endfor
