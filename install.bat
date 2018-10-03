@echo off

goto :main

:link
REM del %1 2>nul
mklink %1 %2
goto :EOF


:dlink
REM rmdir %1 2>nul
mklink /D %1 %2
goto :EOF


REM -------------------

:main

setlocal

set HOME=%HOMEDRIVE%%HOMEPATH%\
set DOTFILES=%~dp0

if not exist %HOME%vimfiles (
  mkdir %HOME%vimfiles
)

pushd %HOME%

call :link _vimrc %DOTFILES%.vim\.vimrc
call :dlink vimfiles\autoload %DOTFILES%.vim\autoload
call :dlink vimfiles\plugin %DOTFILES%.vim\plugin
call :dlink vimfiles\snippet %DOTFILES%.vim\snippet

popd

endlocal

pause
