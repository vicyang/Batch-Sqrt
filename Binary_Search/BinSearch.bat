@echo off
setlocal enabledelayedexpansion

for /l %%a in (1,1,100) do (
    call :get_int_of_root %%a root cmp
    perl -e "printf qq(num=%%3d r=%%2d f=%%4.1f cmp=%%2s\n), %%a, !root!, sqrt(%%a), !cmp!"
)
exit


:get_int_of_root
    rem get the integer part of root
    setlocal
    set /a num = %1
    call :length %num% len
    set /a min = 1, max = 9, root_len = len / 2 + len %% 2
    for /l %%n in (2,1,%root_len%) do set min=!min!0&set max=!max!9
    set /a mid = (min+max)/2
    set /a quit = 0

    :binary_search
        rem not support big number now
        set /a product=mid*mid, delta=product-num, range=max-min
        rem echo mid:%mid% delta:%delta% %min% %max%
        rem if product overflow
        if not "%product:-=%" == "%product%" set delta=1
        if !delta! equ 0 (
            set /a quit = 1, cmp=0
        ) else (
            if !delta! gtr 0 set /a max = mid, mid = ^(mid+min^)/2, cmp=1
            if !delta! lss 0 set /a min = mid, mid = ^(mid+max^)/2, cmp=-1
        )
        if !range! leq 1 (set quit=1)
    if %quit% == 0 goto :binary_search
    endlocal &set %2=%mid%& set %3=%cmp%
    goto :eof

:length
    setlocal
    set s=%19876543210
    endlocal&set %2=%n:~9,1%
    goto :eof
