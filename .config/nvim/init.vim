source $HOME/.config/nvim/vim-plug/plugins.vim
source $HOME/.config/nvim/vim-plug/barbar.vim
source $HOME/.config/nvim/vim-plug/coc.nvim
syntax on

set rnu
set number	
set visualbell
set autoindent
set cindent
set smartindent
set smarttab
set softtabstop=4
set ru

"colorscheme codedark
colorscheme onedark
hi Normal guibg=NONE ctermbg=NONE

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


