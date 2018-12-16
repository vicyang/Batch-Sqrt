@echo off
setlocal enabledelayedexpansion
call :temp 1
call :temp 12
call :temp 123
call :temp 1234
pause
exit

:temp
    set u=0
    set tga=0
    call :stringlength "%1" len
    set /a allbit=( %len% +1)/2
    set num=%allbit%
    set tgb=%num%
    set /a num+=1
    for /l %%i in (0 1 %num%) do (set js[%%i]=0)
    echo %allbit%

:StringLength
    set theString=%~1
    if not defined theString goto :eof
    set len=0
    goto StringLength_continue

:StringLength_continue
    set /a len+=1
    set thestring=%thestring:~0,-1%
    if defined thestring goto StringLength_continue
    if not "%2"=="" set %2=!len!
    goto :eof