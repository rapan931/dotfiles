echo hogehoge

mklink %HOMEPATH%"\_vimrc" %HOMEPATH%"\dotfiles\.vim\.vimrc"
mklink /D %HOMEPATH%"\vimfils\autoload" %HOMEPATH%"\dotfiles\.vim\.autoload"
mklink /D %HOMEPATH%"\vimfils\plugin" %HOMEPATH%"\dotfiles\.vim\plugin"
mklink /D %HOMEPATH%"\vimfils\syntax" %HOMEPATH%"\dotfiles\.vim\syntax"
mklink /D %HOMEPATH%"\vimfils\ftdetect" %HOMEPATH%"\dotfiles\.vim\ftdetect"

