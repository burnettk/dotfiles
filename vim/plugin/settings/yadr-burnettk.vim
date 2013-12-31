" Note that yadr changes the Leader key from backslash to comma.
"
" Control left and right to go between buffers. 
" <Leader>z and <Leader>x do the same.
nmap <C-Left> :bp<cr>
nmap <C-Right> :bn<cr>

" allow playback of a macro (stored in q) without having to type the @ sign
nnoremap <silent> <Space> @q

" Paredit keeps parens and other delimiters balanced. 
" It's unintuitive to use, so keep it off by default.
nnoremap <Leader>p :call PareditToggle()<cr>
let g:paredit_mode = 0
let g:PreserveNoEOL = 1

function! PareditToggle()
  if g:paredit_mode
    let g:paredit_mode = 0
  else
    let g:paredit_mode = 1
  endif
endfunction

" set list shows invisible characters. This is a shortcut to toggle `set list`
" to make tabs and spaces obvious:
" set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
nmap <Leader>l :set list!<CR>

" some people claim it's faster to hit jj than to hit the escape key
imap jj <Esc>

" override vim.sensible default
nnoremap Y Y

" these make it really easy to open several files from the same directory:
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <Leader>ew :e %%
map <Leader>es :sp %%
map <Leader>ev :vsp %%
map <Leader>et :tabe %%

" http://stackoverflow.com/questions/4196980/is-it-possible-to-have-vim-automatically-treat-regular-expressions-as-if-v-was

nnoremap <Leader>v :edit $MYVIMRC<CR>

nnoremap <silent> <F6> :GundoToggle<CR>

if has("autocmd")
  " Source the .vimrc file after saving it
  autocmd BufWritePost .vimrc source $MYVIMRC
  
  " generate tags for any user-generated docs when those docs are saved
  autocmd BufWritePost ~/.vim/doc/* :helptags ~/.vim/doc

  " http://vim.1045645.n5.nabble.com/Eliminating-quot-WARNING-The-file-has-been-changed-since-reading-it-quot-td4897127.html
  " https://groups.google.com/forum/#!topic/vim_use/dV1NqpQA2sM
  function! ProcessFileChangedShell()
    if v:fcs_reason == 'mode' || v:fcs_reason == 'time'
      let v:fcs_choice = ''
    else
      let v:fcs_choice = 'ask'
    endif
  endfunction

  autocmd FileChangedShell <buffer> call ProcessFileChangedShell()
endif

if !exists("g:loaded_custom_vim_functions")
  let g:loaded_custom_vim_functions = 1

  fun! CheckForRailsPlugin() "{{{
    let wordUnderCursor = expand("<cword>")
    let fullPluginPath = "vendor/plugins/" . wordUnderCursor
    echo fullPluginPath

    ":!ls fullPluginPath
    execute '!ls ' . expand( fullPluginPath ) 
  endfunction "}}}

  command! CheckForRailsPlugin call CheckForRailsPlugin()
  nnoremap <Leader>, :CheckForRailsPlugin<CR>
endif
