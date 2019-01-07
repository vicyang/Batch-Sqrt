:: Bignum(integer) Square Root, Decimal Solution
:: https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Decimal_(base_10)
:: 523066680/vicyang
:: 2019-01

@echo off
setlocal enabledelayedexpansion
:init
    rem 创建用于计算字符串长度的模板，长度限制为 2^pow
    set "sharp=#"
    set "serial=9876543210"
    set /a pow=11, maxlen=1^<^<pow
    for /l %%a in (1,1,%pow%) do set sharp=!sharp!!sharp!

set precision=20
call :check_one 3
exit /b

:: 独立测试
:check_one
    set ta=!time!
    call :check_first %1 !precision!
    call :decimal_solution %1
    call :time_delta !ta! !time! tu
    echo time used: !tu!
    goto :eof

:: 批量测试
:check_all
    for /l %%a in (1,1,99) do (
        echo test number: %%a
        call :check_first %%a !precision!
        call :decimal_solution %%a
        echo,
    )
    goto :eof

:: 使用其他工具校验/对比结果
:check_first
    perl -Mbignum=p,-%2 -le "print sqrt(%1)" 2>nul
    goto :eof

:: 手算开根方案
:decimal_solution
    setlocal
    set num=%1
    set tnum=%1
    :: 计算长度，判断初始
    call :length %num% len
    set /a mod=len %% 2, tlen=len, base=0
    if %mod% equ 1 (set /a skip=1) else (set /a skip=2)
    set target=!tnum:~0,%skip%!
    set tnum=!tnum:~%skip%!
    :: mid为零时，关联乘积和长度是提前准备好的
    set /a mp_0=0, mplen_0=1

    :: prec 当前精度
    set /a prec = 0
    set /a base_len=0, target_len=skip
    :first
        for /l %%a in (0,1,9) do (
            set /a mp=%%a*%%a
            if !mp! gtr !target! (set /a mid=%%a-1, mp=mid*mid &goto :out_first)
        )

    :out_first
        if %mp% geq 10 (set /a mplen=2) else (set /a mplen=1)
        set /a target=target-mp, target_len+=2
        set target=!target!00
        set /p inp="%mid%"<nul
    
    :dec_loop
        set /a prec+=1
        rem base=base*10+mid*2
        if "%base%" == "0" (
            set /a base=mid*2
            if !base! geq 10 (set /a base_len=2) else (set /a base_len=1)
        ) else (
            set /a db_mid=mid*2
            if !db_mid! geq 10 (set /a dbmidlen=2) else (set /a dbmidlen=1)
            call :bignum_plus !base!0 !db_mid! !base_len!+1 !dbmidlen! base base_len
        )

        set /a tbase_len=base_len+1

        :: 推算下一个数
        :estimate
            if %base_len% gtr 5 (
                set /a est=!target:~0,6!/!base:~0,5!
            ) else (
                set /a est=target/base
            )
            call :cmp %target% %base%0 %target_len% %tbase_len% cmp
            if !cmp! equ -1 (
                set /a mid=0
                set mp=0
                set mplen=0
                goto :out_estimate
            )
            if %target_len% geq %tbase_len% (
                set /a mid=!est:~0,1!
                call :bignum_mp_single !base!!mid! !mid! !tbase_len! 1 mp mplen
                call :cmp !mp! !target! !mplen! !target_len! cmp
                rem echo !mp! !target! !mplen! !target_len! !cmp!
                :: 如果mp超出目标范围
                if !cmp! equ 1 (
                    set /a mid-=1
                    call :bignum_mp_single !base!!mid! !mid! !tbase_len! 1 mp mplen
                )
                
            )
            :out_estimate

        echo,&echo before tg !target!, mp !mp!, base !base!, mid !mid!
        call :bignum_minus %target% %mp% %target_len% %mplen% target target_len

        set /p inp="%mid%"<nul

        :: 如果截取的字符串已经达到被开根数的总长度，直接补0
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
        set /a target_len+=2

        if "%tnum%" == "" (
            :: 如果target只剩下 00，方案结束
            rem if "%target%" == "00" ( goto :dec_loop_out )
            rem if %cmp% == 0 (
            rem     goto :dec_loop_out
            rem ) else (
            rem     :: 当前精度
            rem     if %prec% equ 0 set /p inp="."<nul
            rem     set /a prec+=1
            rem )
        )
    if %prec% leq %precision% (goto :dec_loop)
    :dec_loop_out
    echo,
    endlocal
    goto :eof

:: 比较
:cmp
    if %3 gtr %4 (set /a %5=1&goto :eof)
    if %3 lss %4 (set /a %5=-1&goto :eof)
    :: 如果长度相同，直接按字符串对比
    if "%1" gtr "%2" (set /a %5=1&goto :eof)
    if "%1" lss "%2" (set /a %5=-1&goto :eof)
    if "%1" equ "%2" (set /a %5=0&goto :eof)

:: 大数 乘以 单位数
:bignum_mp_single
    setlocal
    set num_a=%1
    set num_b=%2
    set /a pool = 0, maxid = %3
    set "res="
    for /l %%a in ( 1, 1, %maxid% ) do (
        set /a mp = !num_a:~-%%a,1! * num_b + pool, t = mp %% 10, pool = mp / 10
        set res=!t!!res!
    )

    if %pool% neq 0 (
        set /a maxid+=1
        set res=!pool!!res!
    )
    endlocal&set %5=%res%&set %6=%maxid%
    goto :eof

::大数加法
:bignum_plus
    setlocal
    set num_a=%1
    set num_b=%2
    set /a len_a=%3, len_b=%4
    set /a max = len_a
    if %len_b% gtr %len_a% (set /a max=len_b, len_b=len_a&set num_a=%num_b%&set num_b=%num_a%)
    set /a pool=0
    set res=
    for /l %%n in ( 1, 1, %max% ) do (
        if %%n leq %len_b% (
            set /a t = !num_a:~-%%n,1! + !num_b:~-%%n,1! + pool
        ) else (
            set /a t = !num_a:~-%%n,1! + pool
        )
        set /a mod = t %% 10, pool = t / 10
        set res=!mod!!res!
    )
    if %pool% gtr 0 (set /a max+=1 &set res=1%res%)
    endlocal &set %5=%res%&set %6=%max%
    goto :eof

::大数减法
:bignum_minus
    setlocal
    set num_a=%1
    set num_b=%2
    set /a len_a=%3, len_b=%4
    set /a max = len_a
    if %len_b% gtr %len_a% (set /a max=len_b, len_b=len_a&set num_a=%num_b%&set num_b=%num_a%)

    set /a minus = 0
    set "res="
    for /l %%n in ( 1, 1, %max% ) do (
        if %%n leq %len_b% (
            set /a dt = !num_a:~-%%n,1! - !num_b:~-%%n,1! - minus
        ) else (
            set /a dt = !num_a:~-%%n,1! - minus
        )
        if !dt! lss 0 (
            set /a t = dt + 10, minus=1
        ) else (
            set /a t = dt, minus=0
        )
        set res=!t!!res!
        if !t! equ 0 (set /a zero+=1) else (set /a zero=0)
    )
    set res=!res:~%zero%!
    endlocal &set %5=%res%&set /a %6=%max%-%zero%
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
