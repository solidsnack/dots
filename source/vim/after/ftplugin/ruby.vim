
function! ruby:tab3col()
  " Disable tab expansion and set tabs to show as 3 spaces.
  setlocal noexpandtab tabstop=3 shiftwidth=3 softtabstop=3
  " Disable horrible Ruby indentation that mixes tabs and spaces.
  setlocal indentexpr=
endfunction

function! ruby:spaces2()
  " Set tab expansion and shorten indent.
  setlocal expandtab tabstop=8 shiftwidth=2 softtabstop=2
  " Indent expression is safe sans tabs.
  setlocal indentexpr=GetRubyIndent()
endfunction

command! -nargs=+ -complete=custom,ruby:complete RUBY
\ :silent! call ruby:dispatch("<args>")<CR>

function! ruby:complete(A,C,P)
  return join(keys(g:RUBY), "\n")
endfunction

function! ruby:dispatch(which)
  call g:RUBY[a:which]()
endfunction

let RUBY =
\ { "tab3col" : function("ruby:tab3col")
\ , "spaces2" : function("ruby:spaces2")
\ }


