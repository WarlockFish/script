"let g:terminal_color_0  = '#2e3436'
"let g:terminal_color_1  = '#cc0000'
"let g:terminal_color_2  = '#4e9a06'
"let g:terminal_color_3  = '#c4a000'
"let g:terminal_color_4  = '#3465a4'
"let g:terminal_color_5  = '#75507b'
"let g:terminal_color_6  = '#0b939b'
"let g:terminal_color_7  = '#d3d7cf'
"let g:terminal_color_8  = '#555753'
"let g:terminal_color_9  = '#ef2929'
"let g:terminal_color_10 = '#8ae234'
"let g:terminal_color_11 = '#fce94f'
"let g:terminal_color_12 = '#729fcf'
"let g:terminal_color_13 = '#ad7fa8'
"let g:terminal_color_14 = '#00f5e9'
"let g:terminal_color_15 = '#eeeeec'

" 中文帮助
language messages zh_CN.utf-8
set helplang=cn


" 设置行号 "
set nu
nnoremap <F2> :set nu! nu?<CR>
set cul   

" 启动鼠标 "
if has('mouse') 
	set mouse=a 
endif 

"set selection=exclusive"
"set selectmode=mouse,key"

filetype plugin indent on

" 显示空格和tab键 "
set listchars=tab:>-,trail:-

" 显示括号匹配  "
set showmatch

 
"设置Tab长度为4空格"
set tabstop=4
"设置自动缩进长度为4空格"
set shiftwidth=4
"继承前一行的缩进方式，适用于多行注释"
set autoindent

" 设置粘贴模式 "
" 复制    "
set paste
set pastetoggle=<F9> 
" set clipboard=unnamed

"总是显示状态栏"
set laststatus=2
"显示光标当前位置"
set ruler
"设置搜索高亮 不区分大小写 "
set hlsearch
set ignorecase
"set t_Co=256

"ctrl-s 保存 ctrl-p 解除"
map <C-S> :w<CR>

"让vimrc配置变更立即生效"
autocmd BufWritePost $MYVIMRC source $MYVIMRC

"buffuers快捷键  'Alt +  ←  '  ' Alt + →  ' 
nmap  <M-Right> :bnext!<CR>;
nmap  <M-Left> :bprev!<CR>;

"---------
"插件开始"
call plug#begin('~/.vim/plugged')
"目录树"
Plug 'preservim/nerdtree' 
"注释"
Plug 'preservim/nerdcommenter'
"高亮"
Plug 'frazrepo/vim-rainbow'
"tag
Plug 'vim-scripts/taglist.vim'
"complete
Plug 'ycm-core/YouCompleteMe'
" VIM-airlinw::"
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"图标
Plug 'ryanoasis/vim-devicons'

Plug 'mhinz/vim-startify'
"颜色主题"
" Plug 'morhetz/gruvbox'
Plug 'rakr/vim-one'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'

call plug#end()
"插件结束"
"--------

"-------插件设置--------
" preservim/nerdtree
" 使用Ctrl + n 打开目录
map <C-n> :NERDTreeToggle<CR> 

"ycm 设置
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
"关闭error
let g:ycm_show_diagnostics_ui = 0

" preservim/nerdcommenter
" 注释的时候自动加个空格, 强迫症必配
" let g:NERDSpaceDelims=1

" airline 设置
" 打开
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1 " 使用powerline打过补丁的字体
" let g:airline#extensions#tabline#enabled = 1  "多文件缓冲区
"buffer编号
let g:airline#extensions#tabline#buffer_nr_show=1


let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ }



" 打开24-bit支持
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

set paste





""""  VIM 主题 onedark """

"let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" 斜体
let g:onedark_terminal_italics=1
let g:onedark_termcolors=256
" 全局
"let g:onedark_color_overrides = {
"\ "black": {"gui": "#2F343F", "cterm": "235", "cterm16": "0" },
"\ "purple": { "gui": "#C678DF", "cterm": "170", "cterm16": "5" }
"\}

"if (has("autocmd"))
"  augroup colorextend
"    autocmd!
"    " Make `Function`s bold in GUI mode
"    autocmd ColorScheme * call onedark#extend_highlight("Function", { "gui": "bold" })
"    " Override the `Statement` foreground color in 256-color mode
"    autocmd ColorScheme * call onedark#extend_highlight("Statement", { "fg": { "cterm": 128 } })
"    " Override the `Identifier` background color in GUI mode
"    autocmd ColorScheme * call onedark#extend_highlight("Identifier", { "bg": { "gui": "#333333" } })
"  augroup END
"endif
"
" onedark.vim override: Don't set a background color when running in a terminal;
" just use the terminal's background color
" `gui` is the hex color code used in GUI mode/nvim true-color mode
" `cterm` is the color code used in 256-color mode
" `cterm16` is the color code used in 16-color mode

"if (has("autocmd") && !has("gui_running"))
"  augroup colorset
"    autocmd!
"    let s:white = { "gui": "#404552", "cterm": "128", "cterm16" : "6" }
"    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
"  augroup END
"endif
"

syntax on
set background=dark
colorscheme onedark

"set bg=dark

"""  END    """




""" ONE 主题
"set background=dark 
"colorscheme one
