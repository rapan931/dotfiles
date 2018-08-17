@echo off

goto :main

:link
del %1 2>nul
mklink %1 %2
goto :EOF


:dlink
rmdir %1 2>nul
mklink /D %1 %2
goto :EOF


REM -------------------

:main

setlocal

set HOME=%HOMEDRIVE%%HOMEPATH%\
set DOTFILES=%~dp0

pushd %HOME%

if not exist %HOME%vimfiles (
  mkdir %HOME%vimfiles
)

call :link _vimrc %DOTFILES%.vim\.vimrc
call :dlink vimfiles\autoload %DOTFILES%.vim\autoload
call :dlink vimfiles\plugin %DOTFILES%.vim\plugin
call :dlink vimfiles\snippet %DOTFILES%.vim\snippet

REM msys—p
call :dlink .vim vimfiles

popd

endlocal

pause
