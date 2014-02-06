function! ctrlp#filer#op#create(path) abort
  let newname = input("What's new name: ", a:path)
  if len(newname) == 0
    return
  endif
  if newname[len(newname)-1] == '/'
    if has("win32") || has("win64")
      call system("mkdir " . shellescape(newname))
    else
      call system("mkdir -p " . shellescape(newname))
    endif
  else
    if has("win32") || has("win64")
      call system("copy /y nul " . shellescape(newname))
    else
      call system("touch " . shellescape(newname))
    endif
  endif
endfunction

function! ctrlp#filer#op#delete(path) abort
  if confirm("Are you sure?", "Yes\nNo") != 1
    return
  endif
  if isdirectory(a:path)
    if has("win32") || has("win64")
      call system("rd " . shellescape(a:path))
    else
      call system("rm -r " . shellescape(a:path))
    endif
  else
    if has("win32") || has("win64")
      call system("del " . shellescape(a:path))
    else
      call system("rm " . shellescape(a:path))
    endif
  endif
endfunction

function! ctrlp#filer#op#rename(path) abort
  let newname = input("What new name: ", a:path)
  if len(newname) == 0
    return
  endif
  if has("win32") || has("win64")
    call system("ren " . shellescape(a:path) . " " . shellescape(newname))
  else
    call system("mv " . shellescape(a:path) . " " . shellescape(newname))
  endif
endfunction

function! ctrlp#filer#op#execute(path) abort
  call system(a:path)
endfunction

function! ctrlp#filer#op#open(path) abort
  if has('win32') || has('win64')
    exe "!start rundll32 url.dll,FileProtocolHandler " . shellescape(a:path)
  elseif executable('open')
    call system("open " . shellescape(a:path))
  elseif executable('xdg-open')
    call system("xdg-open " . shellescape(a:path))
  else
    echohl Error | echo "Can not open:" a:path | echohl None
  endif
endfunction
