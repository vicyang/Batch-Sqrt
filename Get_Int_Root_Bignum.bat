@echo off
setlocal enabledelayedexpansion
:init
  set mod=
  set /a maxlen=2000, half=maxlen/2
  for /l %%a in (1,1,%half%) do set mod=!mod!##

set num=1234567654320
call :get_int_of_root %num% int_root cmp

:last
    echo num = %num%, int_root = %int_root%, %cmp%
    if %cmp% neq 0 ( echo this value is the integer part of root )
    rem pause
    exit /b

:get_int_of_root
    rem get the integer part of root
    setlocal
    set num = %1
    call :length %num% len
    set /a min = 1, max = 9, root_len = len / 2 + len %% 2
    for /l %%n in (2,1,%root_len%) do (set min=!min!0& set max=!max!9)
    set /a mid = (min+max)/2
    set /a quit = 0

    :binary_search
        call :bignum_mp %mid% %mid% product
        call :cmp %product% %num% cmp
        set /a range = max - min
        if !cmp! equ 0 (
            set /a quit = 1, cmp=0
        ) else (
            if !cmp! gtr 0 set /a max = mid, mid = ^(mid+min^)/2, cmp=1
            if !cmp! lss 0 set /a min = mid, mid = ^(mid+max^)/2, cmp=-1
        )
        if !range! leq 1 (set quit=1)
    if %quit% == 0 goto :binary_search
    endlocal &set %2=%mid%& set %3=%cmp%
    goto :eof

:bignum_mp
    setlocal
    set num_a=%1
    set num_b=%2
    call :length %num_a% len_a
    call :length %num_b% len_b
    for /l %%b in ( 1, 1, %len_b% ) do ( set ele_b=!ele_b! !num_b:~-%%b,1! )
    for /l %%a in ( 1, 1, %len_a% ) do ( set ele_a=!ele_a! !num_a:~-%%a,1! )
    rem for /l %%a in (0, 1, %attemplen%) do set buff[%%a]=0
    set /a id = 0, sid = 0, maxid = 0
    for %%b in ( %ele_b% ) do (
        set /a sid = id, id += 1
        for %%a in ( %ele_a% ) do (
            set /a buff[!sid!] += %%a * %%b, sid += 1, maxid = sid
        )
    )
    rem Merge
    set /a id = 0
    for /l %%c in ( 0, 1, %maxid% ) do (
        set /a next = %%c+1
        set /a buff[!next!] += buff[%%c]/10, buff[%%c] = buff[%%c] %% 10
    )

    if "!buff[%maxid%]!" == "0" set /a maxid-=1
    set product=
    for /l %%n in (%maxid%, -1, 0) do set product=!product!!buff[%%n]!
    endlocal &set %3=%product%
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
