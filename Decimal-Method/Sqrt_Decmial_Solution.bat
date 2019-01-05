:: Bignum(integer) Square Root, Decimal Solution
:: https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Decimal_(base_10)
:: 523066680/vicyang
:: 2019-01

@echo off
setlocal enabledelayedexpansion
:init
    rem 创建用于计算字符串长度的模板，长度限制为 2^pow
    set "sharp=#"
    set /a pow=11, maxlen=1^<^<pow
    for /l %%a in (1,1,%pow%) do set sharp=!sharp!!sharp!

set num=2
rem set num=10
rem call :get_int_of_root %num% int_root cmp
set precision=100
rem call :check_first %num% %precision%
call :decimal_solution %num%
exit /b

:check_first
    perl -Mbignum=p,-%2 -le "print sqrt(%1)" 2>nul
    goto :eof

:: 手算开根方案
:decimal_solution
    setlocal
    set num=%1
    set tnum=%1
    call :length %num% len
    set /a mod=len %% 2, tlen=len, base=0
    if %mod% equ 1 (set /a skip=1) else (set /a skip=2)
    set target=!tnum:~0,%skip%!
    set tnum=!tnum:~%skip%!
    set mp_0=0

    rem prec 精度
    set /a prec = 0
    set /a tbase_len = 0, equ = 0
    :dec_loop
        set /a min=0, max=10, mid=5, range=max-min, quit=0, equ=0
        set /a tbase_len+=1
        call :length %target% target_len

        :: 预估下一个可能的数，并限制二分搜索的最大值
        :guess
        if %target_len% gtr 3 (
        if %target_len% equ %tbase_len% (
            set /a t_head = %target:~0,2%, b_head = %base:~0,2%
        ) else (
            set /a t_head = %target:~0,3%, b_head = %base:~0,2%
        )
        ) else (goto :out_of_guess)

        for /l %%a in (0,1,9) do (
            set /a t = %%a * b_head
            rem echo !t! !target:~0,2! %%a
            if !t! gtr %t_head% (
                set /a max = %%a, mid = ^(min+max^)/2
                goto :out_of_guess
            )
        )
        :out_of_guess
        rem echo, &echo %base%%mid% %target% %tbase_len% %target_len% max: %max%

        :dec_bin_search
            :: mp = [base*10+mid] * mid
            if "%base%" == "0" (
                set /a tbase = mid
            ) else (
                set tbase=!base!!mid!
            )
            set ta=%time%
            call :bignum_mp %tbase% %mid% %tbase_len% 1 mp mp_len
            set mp_%mid%=%mp%
            set mplen_%mid%=%mp_len%
            rem call :cmp %mp% %target% %mp_len% %target_len% cmp

            :: 比较 - 判断是否超出
            :cmp_begin
            if %mp_len% gtr %target_len% (set /a cmp=1&goto :cmp_end)
            if %mp_len% lss %target_len% (set /a cmp=-1&goto :cmp_end)
            :: 如果长度相同，直接按字符串对比
            if "%mp%" gtr "%target%" (set /a cmp=1&goto :cmp_end)
            if "%mp%" lss "%target%" (set /a cmp=-1&goto :cmp_end)
            if "%mp%" equ "%target%" (set /a cmp=0&goto :cmp_end)
            :cmp_end

            rem call :time_delta %ta% %time% bs_tu
            if %cmp% equ 0 (set /a quit=1, equ=1)
            if %cmp% equ 1 (set /a max=mid )
            if %cmp% equ -1 (set /a min=mid )
            if %range% leq 1 ( set /a quit=1 )
            set /a mid=(max+min)/2, range=max-mid
        if %quit% == 0 goto :dec_bin_search
        
        set ta=%time%
        set /p inp="%mid%"<nul
        rem echo, &echo tnum %tnum%, cmp %cmp%, equ %equ%, tg %target%
        if "%tnum%" == "" (
            if %cmp% == 0 (
                goto :dec_loop_out
            ) else (
                rem current precision
                if %prec% equ 0 set /p inp="."<nul
                set /a prec+=1
            )
        )

        rem echo b=%base% tb=%tbase% tg=%target% mp=%mp% mid=%mid%
        set ta=%time%
        call :bignum_minus %target% !mp_%mid%! target
        if %skip% geq %len% (
            set target=%target%00
        ) else (
            if "%target%" == "0" (
                set target=!tnum:~0,2!
            ) else (
                set target=!target!!tnum:~0,2!
            )
            set tnum=!tnum:~2!
            set /a skip+=2
        )

        rem base=base*10+mid*2
        if "%base%" == "0" (
            set /a base=mid*2
        ) else (
            set /a db_mid=mid*2
            call :bignum_plus !base!0 !db_mid! base
        )
        call :time_delta %ta% %time% minus_tu

    if %prec% leq %precision% (goto :dec_loop)
    :dec_loop_out
    echo,
    echo minus_tu %minus_tu%
    endlocal
    goto :eof

::大数乘法
:bignum_mp
    setlocal
    set num_a=%1
    set num_b=%2
    set /a len_a=%3, len_b=%4
    for /l %%b in ( 1, 1, %len_b% ) do ( set ele_b=!ele_b! !num_b:~-%%b,1! )
    for /l %%a in ( 1, 1, %len_a% ) do ( set ele_a=!ele_a! !num_a:~-%%a,1! )
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
    endlocal &set %5=%product%&set /a %6=%maxid%+1
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
