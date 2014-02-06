if get(g:, 'loaded_ctrlp_filer', 0)
  finish
endif
let g:loaded_ctrlp_filer = 1

let s:saved_cpo = &cpo
set cpo&vim

call add(g:ctrlp_ext_vars, {
  \ 'init':   'ctrlp#filer#init()',
  \ 'accept': 'ctrlp#filer#accept',
  \ 'lname':  'filer',
  \ 'sname':  'filer',
  \ 'type':   'file',
  \ 'sort':   0
  \ })

let s:path = "."

function! s:to_p(str)
  let path = s:path
  if path !~ '[/\\]$'
    let path .= '/'
  endif
  let path .= a:str
  return fnamemodify(simplify(path), ":p")
endfunction

let s:menu = get(g:, 'ctrlp_filer_menu', {
\ "execute": 'ctrlp#filer#op#execute',
\ "open":    'ctrlp#filer#op#open',
\})

function! s:op_menu(path)
  call ctrlp#exit()
  redraw
  let items = sort(filter(keys(s:menu), "len(s:menu[v:val]) > 0"))
  let r = confirm("Operation for: " . a:path, join(items, "\n"))
  redraw!
  if r == 0
    return
  endif
  call function(s:menu[items[r-1]])(a:path)
endfunction

function! ctrlp#filer#init(...)
  nnoremap <buffer> <c-d> :call <SID>op_menu(<SID>to_p(ctrlp#getcline()))<cr>
  let s:path = fnamemodify(get(a:000, 0, s:path), ':p')
  if !get(g:, 'ctrlp_filer_disable_lcd', 0)
    silent! exe "lcd" s:path
  endif
  call ctrlp#init(ctrlp#filer#id())
  return map([".."] + split(glob(s:path . "/*"), "\n"), 'fnamemodify(v:val, ":t") . (isdirectory(v:val) ? "/" : "")')
endfunction

function! ctrlp#filer#accept(mode, str)
  call ctrlp#exit()
  let path = s:to_p(a:str)
  if isdirectory(path)
    silent! call feedkeys(":CtrlPFiler " . path . "\n", "nt")
  else
    call ctrlp#acceptfile('', path)
  endif
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#filer#id()
  return s:id
endfunction

let &cpo = s:saved_cpo
unlet s:saved_cpo
