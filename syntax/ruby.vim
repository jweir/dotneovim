" https://github.com/zackhsi/sorbet.vim/blob/master/syntax/ruby.vim

syntax region SigBlock start="{" end="}" contained
syntax region SigBlock start="\<do\>" end="\<end\>" contained

syntax cluster rubyNotTop add=SigBlock

syntax match Sig "\<sig\>" nextgroup=SigBlock skipwhite

syntax match rubyMagicComment "\c\%<10l#\s*\zs\%(typed\):" contained nextgroup=rubyBoolean skipwhite

highlight default link Sig      Comment
highlight default link SigBlock Comment
