@echo off
rem bignum plus by 523066680
setlocal enabledelayedexpansion

:init
    rem 创建用于计算字符串长度的模板，长度限制为 2^pow
    set "sharp=#"
    set unit=100000000
    set mask=a987654321
    set /a pow=11, maxlen=1^<^<pow
    for /l %%a in (1,1,%pow%) do set sharp=!sharp!!sharp!

set num_a=100000
set num_b=99999
rem for /l %%a in (1,1,2000) do set num_a=!num_a!1
rem for /l %%a in (1,1,2000) do set num_b=!num_b!2

call :length %num_a% len_a
call :length %num_b% len_b
call :bignum_minus_opt %num_a% %num_b% %len_a% %len_b% delta
echo %delta%
exit

::此函数假设参数 a > b
:bignum_minus_opt
    setlocal
    set num_a=%1
    set num_b=%2
    set /a len_a=%3, len_b=%4, max=len_a
    set time_a=%time%

    set /a minus = 0, actlen = 0, left = len_a %% 8, bid = 0
    set "ele="
    for /l %%a in ( 8, 8, %len_a% ) do (set ele=!ele! !num_a:~-%%a,8!)

    
    for /l %%n in ( 1, 1, %max% ) do (
        if %%n leq %len_b% (
            set /a dt = !num_a:~-%%n,1! - !num_b:~-%%n,1! - minus
        ) else (
            set /a dt = !num_a:~-%%n,1! - minus
        )
        if !dt! lss 0 (
            set /a buff[%%n] = dt + 10, minus=1
        ) else (
            set /a buff[%%n] = dt, minus=0
        )
    )

    set delta=#
    for /l %%a in (%max%, -1, 1) do set delta=!delta:#0=#!!buff[%%a]!
    call :time_delta %time_a% %time% tu
    echo time used: %tu%
    endlocal &set %5=%delta:#=%
    goto :eof

::字符串长度计算
:length %str% %vname%
    setlocal
    set test=%~1_%sharp%
    set test=!test:~0,%maxlen%!
    set test=%test:*_=%
    set /a len=maxlen-(%test:#=1+%1)
    endlocal &set %2=%len%
    goto :eof

:: plp626的时间差函数 时间跨度在1分钟内可调用之；用于测试一般bat运行时间
:time_delta <beginTimeVar> <endTimeVar> <retVar> // code by plp626
    setlocal
    set ta=%1&set tb=%2
    set /a "c=1!tb:~-5,2!!tb:~-2!-1!ta:~-5,2!!ta:~-2!,c+=-6000*(c>>31)"
    if defined %3 set /a c+=!%3!
    endlocal&set %3=%c%
    goto:eof