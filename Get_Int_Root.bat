@echo off
setlocal enabledelayedexpansion
:init
  set mod=
  set /a maxlen=2000, half=maxlen/2
  for /l %%a in (1,1,%half%) do set mod=!mod!##

set /a num=12356
call :get_int_of_root %num% int_root cmp

:last
    echo num = %num%, int_root = %int_root%, %cmp%
    if %cmp% neq 0 ( echo this value is the integer part of root )
    rem pause
    exit /b

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

:length %str% %vname%
    setlocal
    set test=%~1_%mod%
    set test=!test:~0,%maxlen%!
    set test=%test:*_=%
    set /a len=maxlen-(%test:#=1+%1)
    endlocal &set %2=%len%
    goto :eof

:cmp %str1% %str2% %vname%
    setlocal
    call :length %1 len_a
    call :length %2 len_b
    if "%len_a%" gtr "%len_b%" (endlocal &set %3=1&goto :eof)
    if "%len_a%" lss "%len_b%" (endlocal &set %3=-1&goto :eof)
    set str1=%1
    set str2=%2
    if %len_a% equ %len_b% (
        for /l %%n in (0, 1, %len_a%) do (
            if "!str1:~%%n,1!" gtr "!str2:~%%n,1!" (endlocal &set %3=1&goto :eof)
            if "!str1:~%%n,1!" lss "!str2:~%%n,1!" (endlocal &set %3=-1&goto :eof)
        )
        endlocal &set %3=0
    )
    goto :eof
