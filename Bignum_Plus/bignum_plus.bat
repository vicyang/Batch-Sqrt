@echo off
rem bignum plus by 523066680
setlocal enabledelayedexpansion

:init
    rem 创建用于计算字符串长度的模板，长度限制为 2^pow
    set "sharp=#"
    set /a pow=11, maxlen=1^<^<pow
    for /l %%a in (1,1,%pow%) do set sharp=!sharp!!sharp!

set num_a=99999
set num_b=999
for /l %%a in (1,1,2000) do set num_a=!num_a!1
for /l %%a in (1,1,1000) do set num_b=!num_b!1
call :check_first %num_a%+%num_b%
call :bignum_plus %num_a% %num_b% sum
echo %sum%
rem set /a test = num_a + num_b
exit

:check_first
    perl -Mbignum -le "print %1" 2>nul
    goto :eof

:bignum_plus
    setlocal
    set num_a=%1
    set num_b=%2
    set ta=%time%
    call :length %num_a% len_a
    call :length %num_b% len_b
    set /a max = len_a
    if %len_b% gtr %len_a% (set /a max=len_b, len_b=len_a&set num_a=%num_b%&set num_b=%num_a%)

    set /a pool=0
    for /l %%n in ( 1, 1, %max% ) do (
        if %%n leq %len_b% (
            set /a t = !num_a:~-%%n,1! + !num_b:~-%%n,1! + pool
        ) else (
            set /a t = !num_a:~-%%n,1! + pool
        )
        set /a buff[%%n] = t %% 10, pool = t / 10
    )

    if %pool% gtr 0 (set /a max+=1,res=1) else (set res=)
    for /l %%a in (%max%, -1, 1) do set res=!res!!buff[%%a]!

    call :time_delta %ta% %time% tu
    echo time used: %tu%
    endlocal &set %3=%res%
    goto :eof
    
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
