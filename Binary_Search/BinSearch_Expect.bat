@echo off
setlocal enabledelayedexpansion

set "arr=0.0"
for /l %%a in (5,10,95) do (
    set ele=0%%a
    set arr=!arr! !ele:~-2,1!.!ele:~-1,1!
)

set /a times = 0
for %%a in ( %arr% ) do (
    call :bin_search %%a check times
    echo %%a - !check!
)

echo times: %times%
exit /b

:bin_search
    setlocal
    set expect=%1
    set /a min = 0, max = 10, mid = (min+max)/2
    set /a quit = 0, lp_times=0
    :loop
        set /a lp_times+=1
        set test=%mid%.0
        set /p inp="min=%min% max=%max% test=%test% "<nul
        if %test% equ %expect% set /a quit=1, cmp=0
        if %test% gtr %expect% set /a max=mid, mid=(max+min)/2, cmp=1
        if %test% lss %expect% set /a min=mid, mid=(max+min)/2, cmp=-1
        set /a range=max-min
        if %range% equ 1 (set quit=1)
        echo %cmp%
    if %quit% == 0 goto :loop
    if "%mid%,%cmp%" == "1,1" set mid=0

    endlocal&set %2=%mid%&set /a %3=%3+%lp_times%
    goto :eof
