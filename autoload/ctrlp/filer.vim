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
function! ctrlp#filer#init(...)
  let s:path = fnamemodify(get(a:000, 0, s:path), ':p')
  call ctrlp#init(ctrlp#filer#id())
  return map([".."] + split(glob(s:path . "/*"), "\n"), 'fnamemodify(v:val, ":t") . (isdirectory(v:val) ? "/" : "")')
endfunction

function! ctrlp#filer#accept(mode, str)
  call ctrlp#exit()
  let path = fnamemodify(s:path . "/" . a:str, ":p")
  if isdirectory(path)
    exe "CtrlPFiler" path
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
