if exists("did_load_filetypes")
  finish
endif
augroup markdown
  au! BufRead,BufNewFile *.mkd   setfiletype mkd
augroup END

augroup mkd
  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:>
augroup END

" Handle escript Erlang files.
au BufRead *
\ if getline(1) =~ '^#!.*\<escript\>' |
\   set filetype=erlang |
\ endif

" /etc/init.d/ scripts rooted elsewhere
au BufNewFile,BufRead */etc/init.d/*
\ if getline(1) ==? "#!/sbin/runscript" |
\     set filetype=gentoo-init-d |
\ endif

augroup filetypedetect
  " those little /tmp files generated when I'm using vim
  " as a line editor should definitely be colored in.
  au! BufRead,BufNewFile */bash-fc-* setfiletype sh
  " it's important that .hrl files should be colored as .erl files
  au! BufRead,BufNewFile *.hrl setfiletype erlang
  " xen's .xm files are Python
  au! BufRead,BufNewFile *.xm setfiletype python
  " Files that are also Ruby. 
  au! BufRead,BufNewFile *.ru,*.rake,Vagrantfile setfiletype ruby
  " Files from Google mail text areas are mail.
  au! BufRead,BufNewFile mail.google.com_*body_* setfiletype mail
  au! BufRead,BufNewFile *.mail,*.email setfiletype mail
  " NGinX configuration files.
  au! BufRead,BufNewFile nginx.conf,*.nginx setfiletype nginx
  au! BufRead,BufNewFile /etc/nginx/*.conf setfiletype nginx
  au! BufRead,BufNewFile /etc/nginx/*/*.conf setfiletype nginx
  au! BufRead,BufNewFile /etc/nginx/sites-enabled/* setfiletype nginx
  au! BufRead,BufNewFile /etc/nginx/sites-available/* setfiletype nginx
  " Relocated crontabs.
  au! BufRead,BufNewFile *.crontab,*.cron,cron setfiletype crontab
  " Upstart files.
  au! BufNewFile,BufRead */etc/init/*.conf,*/.init/*.conf setfiletype upstart
  au! BufNewFile,BufRead */etc/init/*.override setfiletype upstart
  au! BufNewFile,BufRead */.init/*.override setfiletype upstart
  au! BufNewFile,BufRead upstart,*.upstart setfiletype upstart
  " Postgres is the SQL engine I use most.
  au! BufNewFile,BufRead *.sql,*.psql setfiletype pgsql
  " Markdown, not Modula
  au! BufNewFile,BufRead *.md setfiletype mkd
augroup END

