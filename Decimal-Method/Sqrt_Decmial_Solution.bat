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

set precision=80
rem call :check_one 100
call :check_all
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
    :: 计算长度，判断需要截取的目标长度（1 or 2）
    call :length %num% len
    set /a mod=len %% 2, skip = 2 - mod
    set target=!tnum:~0,%skip%!
    set tnum=!tnum:~%skip%!
    set "base="

    :: prec 当前精度
    set /a prec = 0, base_len=0, target_len=skip

    :dec_loop
        :: 推算下一个数
        :estimate
            :: 如果目标值 小于 基数，下一个数字判定为0
            call :cmp %target% %base%0 %target_len% %base_len%+1 cmp
            if !cmp! equ -1 (
                set /a mid=0, mp=0, mplen=0
                goto :out_estimate
            )

            if %base_len% gtr 5 (
                set /a est=!target:~0,6!/!base:~0,5!
            ) else (
                :: 在set/a计算范围内的，[粗暴]遍历
                for /l %%a in (0,1,10) do (
                    set /a mp=%base%%%a*%%a
                    if !mp! gtr !target! (set /a est=%%a-1 &goto :out_est_for)
                )
            )
            :out_est_for

            :: 199999996400/1999999988 = 99.9999988
            :: but 199999/19999 = 10
            if %est% geq 10 (
                set /a tbase_len=base_len+1
                if !target_len! gtr !tbase_len! (set /a est=9)
            )

            set /a mid=!est:~0,1!
            call :bignum_mp_single !base!!mid! !mid! !base_len!+1 1 mp mplen
            call :cmp !mp! !target! !mplen! !target_len! cmp
            :: 如果mp超出目标范围
            if !cmp! equ 1 (
                set /a mid-=1
                call :bignum_mp_single !base!!mid! !mid! !base_len!+1 1 mp mplen
            )
        :out_estimate

        set /p inp="%mid%"<nul
        rem echo,&echo tg !target!, mp !mp!, base !base!, mid !mid!, est !est!
        if "%tnum%" == "" (
            :: 如果target只剩下 00，方案结束
            if "%target%" == "00" ( goto :dec_loop_out )
            if %cmp% == 0 ( goto :dec_loop_out )
        )

        :: 计算下一段target的值
        call :bignum_minus %target% %mp% %target_len% %mplen% target target_len

        :: 扩充target，如果被开根数已经截取完，直接补0，精度+1
        if %skip% geq %len% (
            set target=%target%00
            set /a prec+=1
            if !prec! equ 1 set /p inp="."<nul
        ) else (
            if "%target%" == "0" (set target=!tnum:~0,2!
                          ) else (set target=!target!!tnum:~0,2!)
            set tnum=!tnum:~2!
            set /a skip+=2
        )
        set /a target_len+=2

        :: 更新基数 - base
        rem base=base*10+mid*2
        if "%base%" == "0" (
            set /a base=mid*2, base_len=1+base/10
        ) else (
            set /a db_mid=mid*2, dbmidlen=1+db_mid/10
            call :bignum_plus !base!0 !db_mid! !base_len!+1 !dbmidlen! base base_len
        )

    if %prec% leq %precision% (goto :dec_loop)
    :dec_loop_out
    echo,
    endlocal
    goto :eof

:: 比较
:cmp
    set /a La=%3, Lb=%4
    if %La% gtr %Lb% (set /a %5=1&goto :eof)
    if %La% lss %Lb% (set /a %5=-1&goto :eof)
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
