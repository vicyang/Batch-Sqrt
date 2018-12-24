:: Bignum(integer) Square Root
:: 523066680/vicyang
:: 2018-12

@echo off
setlocal enabledelayedexpansion
:init
    :: 模板，用于快速计算字符串长度
    set sharp=
    set /a maxlen=2000, half=maxlen/2
    for /l %%a in (1,1,%half%) do set sharp=!sharp!##
    set time_a=%time%

set num=1099511627776
:: set num=10
:: 获取根的整数部分（大范围二分搜索）
call :get_int_of_root %num% int_root cmp

:: 如果cmp返回值为0说明整数根是完整解，无需计算小数部分
if %cmp% equ 0 (
    set root=%int_root%
    echo num = %num%, root = !root!, !cmp!
    pause
    exit /b
)

:: 设置精度
set precision=80
:: 获取根的小数部分，逐位测试并输出（小范围二分搜索，0-9）
call :get_dec_of_root %num% %int_root% %precision% dec_root
pause
exit /b

:check_first
    perl -Mbignum=p,-%2 -le "print sqrt(%1)" 2>nul
    goto :eof

rem 获取根的小数部分，逐位获取。二分搜索
:get_dec_of_root
    setlocal
    set num=%1
    set int_root=%2
    set precision=%3
    set root=%int_root%
    rem Show int_root first
    set /p inp="%int_root%."<nul

    :: 之前的整数根的平方结果
    call :bignum_mp %root% %root% prev_pow

    set /a dec_len=0
    :decroot_lp
    set /a min=0, max=10, mid=(max+min)/2, quit = 0, dec_len+=1
    :decroot_bin_search
        rem 公式分解 [a*10]^2 + 2*[a*10]*b + b^2, part1 part2 part3
        set /a sum = 0
        set part1=%prev_pow%00
        set /a part3 = mid * mid
        set /a double_mid = mid * 2
        call :bignum_mp %root%0 %double_mid% part2
        call :bignum_plus %part1% %part2% sum
        call :bignum_plus %sum% %part3% sum

        rem compare
        call :cmp %sum% %num%00 cmp
        rem echo %root%%mid% %sum% %num%00 min:%min% max:%max% %cmp% 
        set /a range=max-min
        if %cmp% gtr 0 ( set /a max=mid )
        if %cmp% lss 0 ( set /a min=mid )
        if %cmp% equ 0 ( set /a quit=1 )
        if %range% leq 1 ( set /a quit=1 )
        set /a mid=(max+min)/2
    if %quit% equ 0 goto :decroot_bin_search

    :: 更新当前root精度，以及对应的平方值 prev_pow
    set prev_pow=%sum%
    set root=%root%%mid%
    set num=%num%00
    set /p inp="%mid%"<nul

    :: 如果达到指定精度，退出循环
    if %dec_len% lss %precision% goto :decroot_lp
    echo,
    endlocal
    goto :eof

:: 获取根的整数解（大范围二分搜索）
:get_int_of_root
    setlocal
    set num=%1
    call :length %num% len
    :: 预判根的整数位数 初始化搜索范围的最小值和最大值
    set /a min = 1, max = 10, root_len = len / 2 + len %% 2
    for /l %%n in (2,1,%root_len%) do (set min=!min!0& set max=!max!0)
    call :bignum_plus %min% %max% sum
    :: 中间值 = sum / 2
    call :bignum_div_single %sum% 2 mid
    
    set /a quit = 0
    :binary_search
        call :bignum_mp %mid% %mid% product
        call :cmp %product% %num% cmp
        call :bignum_minus %max% %min% range

        if !cmp! equ 0 (
            set /a quit = 1
        ) else (
            if !cmp! gtr 0 (set max=!mid!)
            if !cmp! lss 0 (set min=!mid!)
            call :bignum_plus !max! !min! sum
            call :bignum_div_single !sum! 2 mid
            rem Using !var!, because we are inside the brackets
        )
        if %range% leq 1 (set quit=1)
    if %quit% == 0 goto :binary_search
    endlocal &set %2=%mid%& set %3=%cmp%
    goto :eof

::大数乘法
:bignum_mp
    setlocal
    set num_a=%1
    set num_b=%2
    call :length %num_a% len_a
    call :length %num_b% len_b
    for /l %%b in ( 1, 1, %len_b% ) do ( set ele_b=!ele_b! !num_b:~-%%b,1! )
    for /l %%a in ( 1, 1, %len_a% ) do ( set ele_a=!ele_a! !num_a:~-%%a,1! )
    set /a id = 0, sid = 0, maxid = 0
    for %%b in ( %ele_b% ) do (
        set /a sid = id, id += 1
        for %%a in ( %ele_a% ) do (
            set /a buff[!sid!] += %%a * %%b, sid += 1, maxid = sid
        )
    )
    
    :: 更新每一位的"溢出"值
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

::大数加法
:bignum_plus
    setlocal
    set num_a=%1
    set num_b=%2
    call :length %num_a% len_a
    call :length %num_b% len_b
    set /a max = len_a
    if %len_b% gtr %len_a% (set /a max=len_b, len_b=len_a&set num_a=%num_b%&set num_b=%num_a%)

    for /l %%n in ( 1, 1, %max% ) do (
        if %%n leq %len_b% (
            set /a buff[%%n] = !num_a:~-%%n,1! + !num_b:~-%%n,1!
        ) else (
            set buff[%%n]=!num_a:~-%%n,1!
        )
    )

    set /a id = 0
    for /l %%c in ( 0, 1, %max% ) do (
        set /a next = %%c+1
        set /a buff[!next!] += buff[%%c]/10, buff[%%c] = buff[%%c] %% 10
    )

    if "!buff[%next%]!" gtr "0" set /a max+=1
    set sum=
    for /l %%a in (%max%, -1, 1) do set sum=!sum!!buff[%%a]!
    endlocal &set %3=%sum%
    goto :eof

::大数减法
:bignum_minus
    setlocal
    set num_a=%1
    set num_b=%2
    call :length %num_a% len_a
    call :length %num_b% len_b
    set /a max = len_a
    if %len_b% gtr %len_a% (set /a max=len_b, len_b=len_a&set num_a=%num_b%&set num_b=%num_a%)

    set /a minus = 0
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
    endlocal &set %3=%delta:#=%
    goto :eof

::大数除法（仅限于单个数字的除数）
:bignum_div_single
    setlocal
    set num_a=%1
    set num_b=%2
    call :length %num_a% len_a
    set /a max = len_a, mod = 0
    for /l %%n in ( %len_a%, -1, 1 ) do (
        set /a e = !num_a:~-%%n,1! + mod*10
        set /a buff[%%n] = e/num_b, mod = e %% num_b
    )
    if !buff[%max%]! == 0 (set /a max-=1)

    set quotaint=
    for /l %%a in (%max%, -1, 1) do set quotaint=!quotaint!!buff[%%a]!
    endlocal &set %3=%quotaint%
    goto :eof

::判断字符串长度
:length %str% %vname%
    setlocal
    set test=%~1_%sharp%
    set test=!test:~0,%maxlen%!
    set test=%test:*_=%
    set /a len=maxlen-(%test:#=1+%1)
    endlocal &set %2=%len%
    goto :eof

::比较数字大小（支持长数字）
:cmp %str1% %str2% %vname%
    setlocal
    call :length %1 len_a
    call :length %2 len_b
    if %len_a% gtr %len_b% (endlocal &set %3=1&goto :eof)
    if %len_a% lss %len_b% (endlocal &set %3=-1&goto :eof)
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

::时间计算函数，有BUG
:time_used %time_a% %time_b%
    rem only for few seconds, not consider minutes
    setlocal
    set ta=%1& set tb=%2
    rem insert 1 befeore 00.00 if first num is zero
    set ta=1%ta:~-5%
    set tb=1%tb:~-5%
    set /a dt = %tb:.=% - %ta:.=%
    set dt=%dt:-=%
    set dt=0000%dt%
    set dt=%dt:~-4%
    echo time used: %dt:~0,2%.%dt:~2,2%s
    endlocal
    goto :eof

