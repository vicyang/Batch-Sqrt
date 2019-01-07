@echo off
setlocal enabledelayedexpansion

for /l %%a in (1,1,9) do (
    call :bin_search %%a check
    echo %%a - !check!
)
exit /b

:bin_search
    setlocal
    set /a expect = %1
    set /a min = 1, max = 9, mid = (min+max)/2
    set /a quit = 0
    :loop
        set /p inp="min=%min% max=%max% mid=%mid%"<nul
        if %mid% equ %expect% set /a quit=1, cmp=0
        if %mid% gtr %expect% set /a max=mid-1, mid=(max+min)/2, cmp=1
        if %mid% lss %expect% set /a min=mid+1, mid=(max+min)/2, cmp=-1
        if %max% leq %min% (set quit=1)
        echo  %cmp%
    if %quit% == 0 goto :loop
    rem echo min=%min% max=%max% mid=%mid% %cmp%

    endlocal&set %2=%mid%
    goto :eof
