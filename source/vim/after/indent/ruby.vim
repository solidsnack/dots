
" Disable horrible Ruby indentation that mixes tabs and spaces.
setlocal indentexpr=

" Underline tabs so we always see them.
syntax match Tab /\t/
hi Tab ctermfg=cyan cterm=underline
