@echo off
setlocal enabledelayedexpansion

set echo=rem
for /l %%a in (0,1,99) do (
    call :get_int_of_root %%a root cmp
    perl -e "printf qq(num=%%3d r=%%2d f=%%4.1f cmp=%%2s\n), %%a, !root!, sqrt(%%a), !cmp!"
)

set echo=echo
echo,
call :get_int_of_root 0 root cmp

echo,
call :get_int_of_root 82 root cmp
exit


:get_int_of_root
    rem get the integer part of root
    setlocal
    set /a num = %1
    call :length %num% len
    set /a min = 0, max = 10, root_len = len / 2 + len %% 2
    for /l %%n in (2,1,%root_len%) do set min=!min!0&set max=!max!9
    set /a mid = (min+max)/2
    set /a quit = 0

    :binary_search
        set /a product=mid*mid, range=max-min
        if %product% equ %num% set /a quit = 1, cmp=0
        if %product% gtr %num% set /a max = mid, cmp=1
        if %product% lss %num% set /a min = mid, cmp=-1
        if %range% leq 1 set /a quit = 1
        %echo% tg=%num% pow=%product% min:%min% max:%max% mid:%mid% %cmp%
        set /a mid=(min+max)/2
    if %quit% == 0 goto :binary_search
    %echo% tg=%num% pow=%product% min:%min% max:%max% mid:%mid%
    endlocal &set %2=%mid%& set %3=%cmp%
    goto :eof

:length
    setlocal
    set s=%19876543210
    endlocal&set %2=%n:~9,1%
    goto :eof
