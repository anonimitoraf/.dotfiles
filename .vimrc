set encoding=utf8

execute pathogen#infect()

"==============================================================
" BASE VIMRC from vim.wikia
"==============================================================
" URL: http://vim.wikia.com/wiki/Example_vimrc
" Authors: http://vim.wikia.com/wiki/Vim_on_Freenode
" Description: A minimal, but feature rich, example .vimrc. If you are a
"              newbie, basing your first .vimrc on this file is a good choice.
"              If you're a more advanced user, building your own .vimrc based
"              on this file is still a good idea.
 
"-----------------------------------------------------------
" Features {{{1
"
" These options and commands enable some very useful features in Vim, that
" no user should have to live without.
 
" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible
 
" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on
 
" Enable syntax highlighting
syntax on
 
 
"------------------------------------------------------------
" Must have options {{{1
"
" These are highly recommended options.
 
" Vim with default settings does not allow easy switching between multiple files
" in the same editor window. Users can use multiple split windows or multiple
" tab pages to edit multiple files, but it is still best to enable an option to
" allow easier switching between files.
"
" One such option is the 'hidden' option, which allows you to re-use the same
" window and switch from an unsaved buffer without saving it first. Also allows
" you to keep an undo history for multiple files when re-using the same window
" in this way. Note that using persistent undo also lets you undo in multiple
" files even in the same window, but is less efficient and is actually designed
" for keeping undo history after closing Vim entirely. Vim will complain if you
" try to quit without saving, and swap files will keep you safe if your computer
" crashes.
set hidden
 
" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window as mentioned above, and/or either of the following options:
" set confirm
" set autowriteall
 
" Better command-line completion
set wildmenu
 
" Show partial commands in the last line of the screen
set showcmd
 
" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch
 
" Modelines have historically been a source of security vulnerabilities. As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" set nomodeline
 
 
"------------------------------------------------------------
" Usability options {{{1
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.
 
" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase
 
" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start
 
" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent
 
" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline
 
" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler
 
" Always display the status line, even if only one window is displayed
set laststatus=2
 
" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm
 
" Use visual bell instead of beeping when doing something wrong
set visualbell
 
" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=
 
" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2
 
" Display line numbers on the left
set number
 
" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200
 
" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

"===========================================
" BASIC SETTINGS
"===========================================
set t_Co=256
set t_ut=
colorscheme fahrenheit
set mouse=a
set clipboard^=unnamed
set expandtab       " Expand TABs to spaces
set tabstop=2       " The width of a TAB is set to 2. Still it is a \t. It is just that Vim will interpret it to be having a width of 2.
set shiftwidth=2    " Indents will have a width of 2
set softtabstop=2   " Sets the number of columns for a TAB
set nobackup
set noswapfile
set number
set relativenumber
set splitright
set splitbelow

" auto-save when focus is lost (exludes untitled buffers which will need to be
" saved manually)
autocmd BufLeave,FocusLost * silent! wall

" auto-completion to display longest match first
" and to display even if there's only one match
set completeopt=longest,menuone
" inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  "\ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
"inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  "\ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

"autocmd FileType haskell setlocal wrap

" Use a blinking upright bar cursor in Insert mode, a blinking block in normal
if &term == 'xterm-256color' || &term == 'screen-256color'
    let &t_SI = "\<Esc>[5 q"
    let &t_EI = "\<Esc>[1 q"
endif

if exists('$TMUX')
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
endif

"============================================================
"SYNTASTIC
"============================================================
" map <Leader>s :SyntasticToggleMode<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_haskell_checkers = ['hdevtools']

"============================================================
"AIRLINE
"============================================================
let g:airline_theme='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

"============================================================
"EASYMOTION
"============================================================
" Prefix
nmap <Space> <Plug>(easymotion-prefix)

" 2 character search
map <Space><Space>s <Plug>(easymotion-s2)

" Move to line
map <Space>L <Plug>(easymotion-bd-jk)

" Move to word
map <Space>w <Plug>(easymotion-bd-w)

" Map movement keys
let g:EasyMotion_startofline = 0 "keep cursor column when JK motion
"map <Space>; <Plug>(easymotion-lineforward)
map <Space>j <Plug>(easymotion-j)
map <Space>k <Plug>(easymotion-k)
"map <Space>j <Plug>(easymotion-linebackward)

"vim's smartcase
let g:EasyMotion_smartcase = 1
"============================================================
"NERDTREE
"============================================================
let NERDTreeShowHidden=1

" Start NERDTree
autocmd VimEnter * NERDTree

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Jump to the main window.
"autocmd VimEnter * wincmd p

map <F4> :so ~/.vimrc<CR>
map <F3> :NERDTreeToggle<CR>
"===========================================
"NECO-GHC
"===========================================
let g:haskellmode_completion_ghc = 1
let g:necoghc_enable_detailed_browse = 1
let g:necoghc_use_stack = 1
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

"===========================================
"HDEVTOOLS
"===========================================
nmap gt :HdevtoolsType<CR>
nmap gc :HdevtoolsClear<CR>

"===========================================
"OMNI-COMPLETION
"===========================================
" Use <C-Space> for intellisense
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-x><C-o>

" Move up and down in autocomplete with <c-j> and <c-k>
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>

"==============================================================
"TSUUYOMI
"==============================================================
"let g:tsuquyomi_completion_detail = 1
"autocmd FileType typescript setlocal completeopt+=menu,preview

"map <F12> :TsuquyomiDefinition<CR>
"map <A-F12> :TsuquyomiTypeSplitDefinition<CR>
"map <C-_> :TsuquyomiGoBack<CR>
"map <A-F> :TsuquyomiReferences<CR>

"nmap <Space>h :echo tsuquyomi#hint()<CR>

"==============================================================
"TABULAR
"==============================================================
let g:haskell_tabular = 1

vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a- :Tabularize /-><CR>

"==============================================================
"VIMSHELL
"==============================================================
let g:vimshell_prompt = "vimshell$ "
let g:vimshell_user_prompt = 'join(["\n", fnamemodify(getcwd(), ":~")], "")'
let g:vimshell_popup_command = "vsplit"

map <Space>v <Plug>(vimshell_split_create)
 inoremap <buffer> <expr><silent> <Up> unite#sources#vimshell_history#start_complete(!0)

"==============================================================
"CTRL P
"==============================================================
map <C-E> :CtrlP()<CR>
noremap <leader>b<space> :CtrlPBuffer<cr>
let g:ctrlp_custom_ignore = '\v[\/]dist$'

"==============================================================
"NERD COMMENTER
"==============================================================
" Toggle comment
nnoremap <space>c :call NERDComment(0,"toggle")<CR>
vnoremap <space>c :call NERDComment(0,"toggle")<CR>

"==============================================================
"VIM-HOOGLE
"==============================================================
let g:hoogle_search_count = 20
let g:hoogle_search_buf_size = 20

au BufNewFile,BufRead *.hs map <C-h><C-h> :Hoogle 
au BufNewFile,BufRead *.hs map <C-h> :HoogleInfo 
au BufNewFile,BufRead *.hs map <C-h><C-x> :HoogleClose<CR>
"au BufNewFile,BufRead *.hs map <S-F3> :HoogleLine<CR>

"==============================================================
"SUPERTAB
"==============================================================
"let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
"let g:SuperTabDefaultCompletionType = "<C-n>"
"let g:SuperTabContextDefaultCompletionType = "<C-n>"
"let g:SuperTabLongestHighlight

"==============================================================
"GENERAL MAPPINGS
"==============================================================

" auto start with the main tab pane
au VimEnter * wincmd l

" open terminal below
map <C-i> :terminal<CR>

" resizing splits
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

map <F4> :so ~/.vimrc<CR>

vnoremap <expr> // 'y/\V'.escape(@",'\').'<CR>'

"nmap <C-S-V> "+gP
"imap <C-S-V> <ESC><C-S-V>i
vmap <C-C> "+y

"noremap ; l
"noremap l k
"noremap k j
"noremap j h
"noremap h <Nop>

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$
 
" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
"nnoremap <C-L> :nohl<CR><C-L>

" Tab keys
map  <C-n> :tabnew<CR>


" Fix for Alt key
"let c='a'
"while c <= 'z'
  "exec "set <A-".c.">=\e".c
  "exec "imap \e".c." <A-".c.">"
  "let c = nr2char(1+char2nr(c))
"endw
"set timeout ttimeoutlen=5

" Move lines (NOTE: It is important that k and l are lower-case)
nnoremap <A-j> :m .+1<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv

nnoremap <A-k> :m .-2<CR>==
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-k> :m '<-2<CR>gv=gv

" debugging colours
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

set rtp+=~/.vim/autoload/tabnine

" TO DO 
" - Refactoring across all files in project
" - unite.vim
" - autoindent whole file (Ctrl K Ctrl D)
