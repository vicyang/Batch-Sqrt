@echo off & SetLocal EnableDelayedExpansion
::变量c的值是被开方数，不得超过1000！
for  /l %%a in (1,1,100) do (
    perl -Mbignum=p,-80 -e "print sqrt(%%a),qq(-\n)"
    call :test %%a
    echo,
)
exit /b

:test
setlocal
set c=%1
for %%a in (16 8 4 2 1) do (
    set /a "d=(a*%%a<<1)+%%a*%%a+b"
    if !c! geq !d! set /a "a+=%%a","b=d"
)
if !b! equ !c! echo !a! & goto :eof
set /p "=!a!."<nul
for %%a in (512 256 128 64 32 16 8 4 2 1) do (
    set /a "d+=%%a","e=((a*d<<1)+d*d/1000)/1000+b"
    if !e! geq !c! set /a "d-=%%a"
)
set "e=00!d!" & set /p "=!e:~-3!"<nul
set /a "e=(!a!!d!*!a!!d!)%%1000000","b=e/1000","e=e%%1000"
set "e=  !e!" & set "e=!e:~-3!"
set "b=  0!e!!b!"
set "e=  !d!"
set "a=!e:~-3!!a!"
for /l %%a in (3 3 80) do (
    set "d=0"
    for %%b in (512 256 128 64 32 16 8 4 2 1) do (
        set /a "d+=%%b"
        if 1000 gtr !d! (
            set /a "c=d*d/1000"
            for /l %%c in (0 3 %%a) do set /a "c=((!a:~%%c,3!*d<<1)+c+!b:~%%c,3!)/1000"
            set /a "e=%%a+3"
            for %%c in (!e!) do set /a "c+=!b:~%%c,3!" & if !c! geq 1000 set /a "d-=%%b"
        ) else set /a "d-=%%b"
    )
    set "e=00!d!" & set /p "=!e:~-3!"<nul
    set "c=" & set /a "f=d*d/1000"
    for /l %%b in (0 3 %%a) do (
    set /a "e=(!a:~%%b,3!*d<<1)+!b:~%%b,3!+f","f=e/1000","e%%=1000"
    set "e=  !e!" & set "c=!c!!e:~-3!"
    )
    set /a "e=(d*d)%%1000" & set "e=  !e!" & set "b=  0!e:~-3!!c!"
    set "e=  !d!" & set "a=!e:~-3!!a!"
)
echo. & endlocal & goto :eof
