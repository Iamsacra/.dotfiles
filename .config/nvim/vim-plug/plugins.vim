" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    "Color scheme
    "Plug 'tomasiser/vim-code-dark'
    Plug 'joshdick/onedark.vim'
    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    "Startscreen
    Plug 'mhinz/vim-startify'
    "css Colors
    Plug 'ap/vim-css-color'    
    "Tabs
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'romgrk/barbar.nvim'    
    "Syntax check
    Plug 'vim-syntastic/syntastic'    
    "HTML Syntax
    Plug 'mattn/emmet-vim'    
    "Emmet
    Plug 'mattn/emmet-vim'
    "Javascript
    Plug 'pangloss/vim-javascript'
    "coc
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

nnoremap <C-l> :NERDTreeToggle<CR>
