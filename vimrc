set clipboard=unnamedplus
set nocompatible             " required
filetype off                 " required
set fileformat=unix
syntax on

call plug#begin('~/.vim/plugged')
Plug 'rust-lang/rust.vim'
Plug 'vimwiki/vimwiki'
Plug 'NoahTheDuke/vim-just'
Plug 'elzr/vim-json'
Plug 'chrisbra/csv.vim'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'junegunn/goyo.vim'
Plug 'lervag/vimtex'
Plug 'vim-airline/vim-airline'
Plug 'sbdchd/neoformat'
Plug 'ycm-core/YouCompleteMe'
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'rhysd/vim-grammarous'
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'preservim/nerdtree'
Plug 'dense-analysis/ale'
Plug 'preservim/nerdcommenter'
Plug 'poliquin/stata-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'ncm2/ncm2'
" Plug 'ncm2/ncm2-jedi'
" Plug 'ncm2/ncm2-bufword'
" Plug 'ncm2/ncm2-path'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'roxma/nvim-yarp'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'morhetz/gruvbox'
Plug 'tomasr/molokai'
Plug 'fmoralesc/molokayo'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
call plug#end()           " required

filetype plugin indent on   " required

colorscheme dracula
set background=dark
let g:airline_theme='dracula'
set termguicolors

let g:deoplete#enable_at_startup = 1
" autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect

let g:LanguageClient_serverCommands = {'rust': ['rust-analyzer'] }

" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:ycm_autoclose_preview_window_after_completion=1

au BufNewFile,BufRead *.py
           \ set tabstop=4 |
           \ set softtabstop=4 |
           \ set shiftwidth=4 |
           \ set textwidth=79 |
           \ set expandtab |
           \ set autoindent |
           \ set fileformat=unix

let python_highlight_all=1

let g:vimtex_view_method='zathura'
" vimtex settings
let g:vimtex_quickfix_latexlog = {
         \ 'overfull' : 0,
         \ 'underfull' : 0,
         \ 'packages' : {
         \   'default' : 0,
         \ },
         \}
let g:vimtex_quickfix_autoclose_after_keystrokes=3
let g:vimtex_quickfix_ignore_filters = [
         \ '.*warning.*',
         \ '.*Warning.*',
         \ '.*hbox.*',
         \]

let &t_SI = "\<esc>[5 q"
let &t_SR = "\<esc>[5 q"
let &t_EI = "\<esc>[2 q"
" settings from python setup
let g:plugged_home = '~/.vim/plugged'

let g:fzf_action = {
 \ 'Enter': 'tab split'}

let g:fzf_layout = { 'window': { 'width': 1.0, 'height': 0.9, 'relative': v:true } }

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg -i --column --line-number --no-heading --color=always -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

augroup autoformat_settings
 autocmd FileType bzl AutoFormatBuffer buildifier
 autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
 autocmd FileType dart AutoFormatBuffer dartfmt
 autocmd FileType go AutoFormatBuffer gofmt
 autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
 autocmd FileType java AutoFormatBuffer google-java-format
 autocmd FileType python AutoFormatBuffer yapf
 " Alternative: autocmd FileType python AutoFormatBuffer autopep8
augroup END

set undofile
set undodir=/tmp/

nnoremap c "_c
set nocompatible
filetype plugin on
syntax on
set encoding=utf-8
set number relativenumber
set tabstop=4
set shiftwidth=4
set splitright
set ic

" ease the write command
nmap m :w<ENTER>:e<ENTER>z.
nmap zz :wq<ENTER>
nmap zx :q!<ENTER>
nmap <C-g> :Files<ENTER>
nmap <C-e> :Goyo 100<ENTER>

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

set autoread

" let mapleader=" "

autocmd BufWritePost *Xresources,*Xdefaults !xrdb %
autocmd VimLeave config.h !sudo make clean install
autocmd VimLeave *.tex !make todo
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre *.tex,*.txt %s/  / /e
autocmd BufWritePre *.tex,*.txt %s/\s\./\./e
autocmd VimLeave *.tex !latexmk -c

autocmd FileType py map ,, <leader>r
autocmd FileType tex nmap ,, <plug>(vimtex-compile)
autocmd FileType tex nmap ` <plug>(vimtex-view)
"autocmd FileType ms nmap ,, !pdf %
autocmd BufNewFile,BufRead *.ms nmap ,, m:!pdf %<ENTER><ENTER>
autocmd BufNewFile,BufRead *.md nmap ,, m:!pdf %<ENTER><ENTER>
"autocmd VimEnter *.tex :call feedkeys(",,")
" make sure set latex syntax coloring
autocmd BufNewFile,BufRead *.tex set syntax=tex

" NerdCommenter
let g:NERDSpaceDelims = 1
let g:NERDToggleCheckAllLines = 1
let g:NERDCreateDefaultMappings = 0
nmap <Space>w <plug>NERDCommenterToggle <Esc>
xmap <Space>w <plug>NERDCommenterToggle <Esc>

" nnoremap <Space>n :NERDTreeFocus<CR>
nnoremap <Space>n :NERDTree<CR>
nnoremap <Space>q :NERDTreeToggle<CR>

nnoremap <Space><Space> <Esc>/<++><Enter>"_c4l

autocmd FileType tex map <leader>w :w !detex \| wc -w<CR>
nnoremap <Space>n :Files<Enter>
" Code snippets
nnoremap <Space>fr o\begin{frame}<Enter>\frametitle{}<Enter>\end{frame}<Enter><++><Esc>kkf}i
nnoremap <Space>fi i\begin{fitch}<Enter><Enter>\end{fitch}<Enter><Enter><++><Esc>3kA
nnoremap <Space>fg i\begin{figure}<Enter>\caption{<++>}<Enter>\includegraphics[scale=0.<++>]{<++>.png}\\<Enter>\end{figure}<Esc>4k
nnoremap <Space>pb o\parbox{\textwidth}{}<Esc>i
nnoremap ,exe i\begin{exe}<Enter>\ex<Space><Enter>\end{exe}<Enter><Enter><++><Esc>3kA
nnoremap ,em i\emph{}<++><Esc>T{i
nnoremap <Space>bf i\textbf{}<Esc>T{i
nnoremap <Space>df i\dfrac{}{<++>}<++><Esc>T{hhi
nnoremap <Space>sm i\sum_{}^{<++>}<++><Esc>T{hhhi
nnoremap <Space>it i\textit{}<++><Esc>T{i
nnoremap <Space>fn i\footnote{}<++><Esc>T{i
nnoremap <Space>lb A<Left>\label{}<Left>
nnoremap <Space>ct bf<Space>a\cite{} <++><Esc>T{i
nnoremap <Space>cp bf<Space>a\citep{} <++><Esc>T{i
nnoremap ,glos {\gll<Space><++><Space>\\<Enter><++><Space>\\<Enter>\trans{``<++>''}}<Esc>2k2bcw
nnoremap <Space>ol o\begin{enumerate}<Enter><Enter>\end{enumerate}<Enter><Enter><++><Esc>3kA\item<Space>
nnoremap ,ee I\[<Esc>A\]<Esc>
nnoremap <Space>eq o\begin{equation}<Enter>\end{equation}<Enter><++><Esc>2kA<ENTER>
nnoremap <Space>al o\begin{align*}<Enter>\end{align*}<Enter><++><Esc>2kA<ENTER>
nnoremap <Space>ul o\begin{itemize}<Enter><Enter>\end{itemize}<Esc>1kA\item<Space>
nnoremap <Space>ii o\item<Space>
nnoremap <Space>h o\hline<Esc>j
nnoremap <Space>rf i\ref{<Esc>f i}<Esc>
nnoremap <Space>tb i\begin{table}<Enter>\footnotesize<Enter>\caption{}<Enter>\end{table}<Enter><Enter><Esc>3kf{a
nnoremap <Space>ta i\begin{tabularx}{}<Enter><++><Enter>\end{tabularx}<Enter><Enter><++><Esc>4kA{}<Esc>hhi\textwidth<Esc>3li
nnoremap <Space>sc i\textsc{}<Space><++><Esc>T{i
nnoremap <Space>sec o\section{}<Enter><++><Esc>1kf}i
nnoremap <Space>ssec o\subsection{}<Esc>i
nnoremap <Space>sssec o\subsubsection{}<Esc>i
nnoremap ,st <Esc>F{i*<Esc>f}i
nnoremap ,beg i\begin{DELRN}<Enter><++><Enter>\end{DELRN}<Enter><Enter><++><Esc>4k0fR:MultipleCursorsFind<Space>DELRN<Enter>c
nnoremap ,up <Esc>/usepackage<Enter>o\usepackage{}<Esc>i
nnoremap ,up /usepackage<Enter>o\usepackage{}<Esc>i
" nnoremap tt :w<ENTER>:!pdf main.tex<ENTER><ENTER>
nnoremap <Space>tt a\texttt{}<Space><++><Esc>T{i
nnoremap ,col i\begin{columns}[T]<Enter>\begin{column}{.5\textwidth}<Enter><Enter>\end{column}<Enter>\begin{column}{.5\textwidth}<Enter><++><Enter>\end{column}<Enter>\end{columns}<Esc>5kA
nnoremap ,rn i(\ref{})<++><Esc>F}i
nnoremap <Space>ig i\includegraphics[scale=0.<++>]{<++>.png}\\<Esc>0
nnoremap <Space>mm a\multicolumn{}{c}{<++>}<ESC>9hi
nnoremap <Space>4 s$$<ESC>Pe
vnoremap <Space>4 s$$<ESC>Pe
nnoremap <Space>9 xi()<ESC>Pe
vnoremap <Space>9 di()<ESC>Pe
nnoremap <Space>' xi''<ESC>Pe
vnoremap <Space>' di''<ESC>Pe
nnoremap <Space>" xi""<ESC>Pe
vnoremap <Space>" di""<ESC>Pe
nnoremap <Space>[ s{}<ESC>Pe
vnoremap <Space>[ s{}<ESC>Pe
nnoremap <Space>r :&&<Enter>
nnoremap <Space>g :RG<Enter>


"Spell checkers
nmap <F5> <Plug>(grammarous-fixit)
nmap <F6> <Plug>(grammarous-move-to-next-error)
nmap <F7> <Plug>(grammarous-move-to-previous-error)
nmap <F9> <Plug>(grammarous-close-info-window)
nmap <F8> :GrammarousCheck<ENTER>
let g:grammarous#use_vim_spelllang = 1

nmap <F9> :set spell<ENTER>
autocmd FileType go nmap ,, :GoRun %<ENTER>
autocmd FileType go nmap { a{<ENTER>}<ESC>O

xnoremap p "_dP

hi Normal guibg=NONE ctermbg=NONE

function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()
