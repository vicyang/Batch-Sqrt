@echo off
setlocal enabledelayedexpansion

:init
    rem static template for calculating strlen
    set "sharp=#"
    set /a pow=11, maxlen=1^<^<pow
    for /l %%a in (1,1,%pow%) do set sharp=!sharp!!sharp!

set num_a=123456
set num_b=9

for /l %%a in (1,1,2000) do (set num_a=!num_a!9)

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
    set /a pool = 0, maxid = len, bar=0, foo=1
    for /l %%a in ( 2, 2, %len% ) do (
        set /a mp = !num_a:~-%%a, 2! * num_b + pool
        set /a buff[!bar!] = mp %% 10, pool = mp/100, ^
                buff[!foo!] = ^(mp/10^) %% 10, f=buff[!foo!], foo+=2, bar+=2
    )

    if %pool% neq 0 set /a maxid+=1, buff[!maxid!] = pool

    set res=
    for /l %%n in (%maxid%, -1, 0) do set res=!res!!buff[%%n]!
    endlocal&set %3=%res%&set %4=%maxid%
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