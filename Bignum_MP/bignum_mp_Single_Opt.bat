@echo off
setlocal enabledelayedexpansion

:init
    rem static template for calculating strlen
    set /a base=100000000
    set "sharp=#"
    set mask=a987654321
    set /a pow=11, maxlen=1^<^<pow
    for /l %%a in (1,1,%pow%) do set sharp=!sharp!!sharp!

set num_a=99900000001
set num_b=9

::for /l %%a in (1,1,1) do (set num_a=!num_a!9)

call :check_first %num_a%*%num_b%

set ta=%time%
call :bignum_mp_single %num_a% %num_b% mp mp_len
call :time_delta %ta% %time% tu
echo %mp%
echo len: %mp_len%
echo time used: %tu%
exit

:check_first
    perl -Mbignum -le "print %1" 2>nul
    goto :eof

:bignum_mp_single
    setlocal
    set num_a=%1
    set num_b=%2
    call :length %num_a% len
    rem actlen 是实际长度，bid是序列数组长度
    set /a pool = 0, actlen = 0, left = len %% 8, bid = 0
    set "ele="
    for /l %%a in ( 8, 8, %len% ) do (set ele=!ele! !num_a:~-%%a,8!)
    :: 消除前置0
    for /l %%a in (1,1,7) do (set ele=!ele: 0= !)

    for %%a in (%ele%) do (
        set /a mp = %%a * num_b + pool, actlen+=8, bid+=1
        set /a v = mp %% base, buff[!bid!] = base+v, pool = mp / base
    )

    set res=
    for /l %%n in (%bid%, -1, 1) do set res=!res!!buff[%%n]:~1!

    ::如果最左还有字段
    if %left% gtr 0 (
        set /a mp = !num_a:~0,%left%!*num_b + pool, pool = mp/base
        set mpmask=!mp!!mask!
        set /a actlen+=0x!mpmask:~10,1!
        set res=!mp!!res!
    ) else (
        rem 如果所有字段清空，考虑高字段刚好进一位的情况
        set res=!pool!!res!
        set /a actlen+=1
    )

    endlocal&set %3=%res%&set %4=%actlen%
    goto :eof
    
:length %str% %vname%
    setlocal
    set test=%1_%sharp%
    set test=!test:~0,%maxlen%!
    set test=%test:*_=%
    set /a len=maxlen-(%test:#=1+%1)
    endlocal &set %2=%len%
    goto :eof

:time_delta <beginTimeVar> <endTimeVar> <retVar> // code by plp626
    setlocal
    set ta=%1&set tb=%2
    set /a "c=1!tb:~-5,2!!tb:~-2!-1!ta:~-5,2!!ta:~-2!,c+=-6000*(c>>31)"
    if defined %3 set /a c+=!%3!
    endlocal&set %3=%c%
    goto:eof