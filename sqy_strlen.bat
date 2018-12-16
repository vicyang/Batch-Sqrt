@echo off
setlocal enabledelayedexpansion
call :StringLenth "abcdefghijklmnopqrstuvwxyzdddddddddddddddddddddddddddsddddddddddddddddddddddddddddddddd" len
echo %len%
pause


:StringLenth
    set theString=%~1
    if not defined theString goto :eof
    set temp=0
    goto StringLenth_continue

:StringLenth_continue
    set /a temp+=1
    set thestring=%thestring:~0,-1%
    if defined thestring goto StringLenth_continue
    if not "%2"=="" set %2=!temp!
    goto :eof