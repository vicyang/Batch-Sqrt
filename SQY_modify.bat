@echo off
title 计算整数平方根的值
color f0
PUSHD %~dp0
cd /d %~dp0
setlocal enabledelayedexpansion
cls
echo ------------------
echo 计算整数平方根的值
echo ------------------
set TIMEA=%time%

:init 
    rem 初始化常量映射表
    set /a iter = 1
    for %%a in ( E_2m E_5m E_4m E_2l U_1 E_7m E_5l E_9m E_7l ) do (
        set /a %%a=iter, iter+=1
    )    
    set /a iter = 0
    for %%a in ( 1m 1l 3m 3l 4l 6m 6l 8m 8l 9l ) do (
        set /a T_%%a=iter, iter+=1
    )

    set /a test_mode = 1
    if "%test_mode%"=="1" (
        set cls=rem&set echo=rem
        goto :test
    ) else (
        set cls=cls
        goto :start
    )

:test
    for %%n in (2 121 25 14641) do (
        set /a number=%%n
        set /a bit=5
        set start=yes
        call :main
    )
    pause
    exit /b

:start
    echo.&echo 请输入被开方数（仅限整数）,然后按回车键：
    echo （被开方数最高为2147483646，超出范围，会计算出错）
    set number=
    set /p "number="
    goto get_number

:get_number
    cls
    if "%number%"=="" goto start
    set /a int_test=%number%+0
    if not "%int_test%"=="%number%" goto error_a
    if not %number% geq 0 goto error_b
    if %number% geq 2147483647 goto error_c
    goto set_precision

:set_precision
    cls
    echo.&echo 请输入精确位数,然后按回车键：
    echo （指精确到小数点后第几位）
    echo （该程序不会对最后一位进行四舍五入）
    echo （精确位数最高为238609294，超出范围，会计算出错）
    echo （对于结果为整数的，程序会舍去小数部分）
    set bit=
    set /p "bit="
    goto chk_precision

:chk_precision
    %cls%
    if "%bit%"=="" goto set_precision
    set /a int_test=%bit%+0
    if not "%bit%"=="%int_test%" goto error_d
    if not %bit% geq 0 goto error_d
    if %bit% geq 238609295 goto error_e
    set start=yes
    goto main

:main
    %cls%
    %echo%.&%echo%  已经开始计算。
    %echo%  每计算一位，都会对结果更新！
    %echo%  越往后计算，结果显示越慢！请耐心等待本程序计算完成。
    %echo%.&%echo% 被开方数：%number%
    if not "%start%"=="yes" (
        set /a num+=1
        set /a dec_bits = num - int_bits - 1
        set /a mod = dec_bits %% 4
        rem 小数点后，每4位数字保留一个空格
        if not "!dec_bits!"=="1" (
            if "!mod!"=="1" (
                set result=%result%^ %root:~-1%
            ) else (
                set result=%result%%root:~-1%
            )
        ) else (
            set result=%result%%root:~-1%
        )
        set /a temp=%dec_bits%+1
        if "!temp!"=="%bit%" goto end
        %echo%.&%echo% 计算结果（未对其结果进行四舍五入）：
        %echo%.&%echo% %result%
        goto js
    ) else (
        %echo%.&%echo% 请稍候……
        goto temp
    )

:temp
    set u=0
    set dec_bits=0
    call :StringLength "%number%" len
    set /a int_bits=( %len% +1)/2
    set num=%int_bits%
    set root_len=%num%
    set /a num+=1
    for /l %%i in (0 1 %num%) do (set RT[%%i]=0)
    
    rem 如果整数部分只有1位
    if "%int_bits%"=="1" (
        set next_ref=RT[1]
        call :select
    ) else (
        for /l %%i in (%root_len% -1 1) do (
            set u=0
            set next_ref=RT[%%i]
            call :select
            set RT[%%i]=!select!
        )
        set select=
        for /l %%i in (%root_len% -1 1) do (
            set select=!select!!RT[%%i]!
        )
    )

    set all=%select%
    set /a product = all * all
    if "%product%"=="%number%" (
        set bit=0
        set result=%all%
        goto end
    )
    if "%bit%"=="0" (
        set result=%all%
        goto end
    )
    set "root=%all%."
    set "result=%all%."
    set start=no
    goto js

:js
    rem root without floating point
    set "int_root=%root:.=%"
    set /a root_len = num - 1
    set next_ref=RT[0]

    rem 建立数组，预留1位
    if "%root_len%"=="1" (
        set RT[1]=%int_root%
    ) else (
        for /l %%i in (%root_len%, -1, 1) do (
            set RT[%%i]=!int_root:~-%%i, 1!
        )
    )

    rem Select next number / Binary Search
    set RT[%num%]=0
    set u=0
    call :select
    set root=%root%%select%
    goto main

:select
    set /a u+=1
    if defined E_%er% (
        set /a %next_ref% = E_%er%
        goto bignum_mp
    )
    
    if defined U_%u% (
        set /a %next_ref% = U_%u%
        goto bignum_mp
    )

    if defined T_%er% set /a select=T_%er%
    goto :eof

:bignum_mp
    rem bignum multiply
    set tgc=0
    set /a tbits=%num%*2-1
    for /l %%i in (%tbits% -1 0) do set dg[%%i]=0
    for /l %%i in (0 1 %root_len%) do (
        for /l %%r in (0 1 %num%) do (
            set /a i=%%i+%%r
            set /a temp=!RT[%%i]!*!RT[%%r]!+!tgc!
            set /a dg[!i!]+=!temp!%%10
            set /a tgc=!temp!/10
        )
        set tgc=0
        if %dec_bits% geq 50 (
            if %dec_bits% geq 100 (
                set /p=<nul
                set /p=总进度^:%u%^(最少3^,最多4^)^,副进度^:%%i^(共%root_len%^)^ ^ ^ ^ <nul
            ) else (
                set /p=<nul
                set /p=总进度^:%u%^(最少3^,最多4^)^ ^ ^ ^ <nul
            )
        )
    )
    
    set /a tbits-=1
    for /l %%i in (0 1 %tbits%) do (
        set /a temp=%%i+1
        set /a dg[!temp!]+=!dg[%%i]!/10
    )
    
    set /a tbits+=1
    set /a tge=1+!tbits!-(%int_bits%*2)
    set tgf=
    for /l %%i in (!tbits! -1 !tge!) do (
        set /a temp=!dg[%%i]!%%10
        if "%%i"=="!tbits!" (
            if not "!temp!"=="0" (
                set tgf=!temp!
            )
        ) else (
            set tgf=!tgf!!temp!
        )
    )
    
    if not "%start%"=="yes" (
        if !tgf! geq %number% (
            set er=!%next_ref%!m
        ) else (
            set er=!%next_ref%!l
        )
    ) else (
        if !tgf! gtr %number% (
            set er=!%next_ref%!m
        ) else (
            set er=!%next_ref%!l
        )
    )
    goto select

:error_a
    cls
    color fc
    echo 错误：输入的被开方数不是整数，请重新输入！
    echo 其绝对值不得超过批处理支持的最大值（2147483647）！
    echo 请不要在整数前加上正号（+）或多余的零！
    echo.&echo 按任意键继续：&pause>nul
    color f0
    cls
    goto start

:error_b
    cls
    color fc
    echo 错误：平方根中被开方数不能小于0，请重新输入！
    echo.&echo 按任意键继续：&pause>nul
    color f0
    cls
    goto start

:error_c
    cls
    color fc
    echo 错误：被开方数不能大于2147483646，请重新输入！
    echo.&echo 按任意键继续：&pause>nul
    color f0
    cls
    goto start

:error_d
    cls
    color fc
    echo 错误：输入的精确位数不是正整数，请重新输入！
    echo 其绝对值不得超过批处理支持的最大值（2147483647）！
    echo 请不要在整数前加上正号（+）或多余的零！
    echo.&echo 按任意键继续：&pause>nul
    color f0
    cls
    goto set_precision

:error_e
    cls
    color fc
    echo 错误：精确位数不能大于238609294，请重新输入！
    echo.&echo 按任意键继续：&pause>nul
    color f0
    cls
    goto set_precision
    
:end
    %cls%
    %echo%.&%echo% 计算完毕！
    rem echo.%TIMEA%
    rem echo.%time%
    echo.&echo 被开方数：%number%
    %echo%.&%echo% 计算结果（未对其结果进行四舍五入）：
    echo !result!
    if "%test_mode%" == "1" goto :eof
    echo.&echo 按任意键继续：&pause>nul
    cls
    echo 请选择接下来的操作。
    echo ---------------------
    echo 0：退出
    echo 1：返回重新计算
    echo 2：将结果保存至桌面。
    echo ---------------------
    set "choice="
    set /p "choice=请输入操作序号，然后按回车键："
    if "%choice%"=="0" exit /b
    if "%choice%"=="1" (
        cls
        goto start
    )
    if "%choice%"=="2" goto save_and_exit
    goto end

:save_and_exit
    if "%bit%"=="0" (
        set info=（保留整数）
    ) else (
        set info=（精确到小数点后第%bit%位）
    )
    cd /d "%UserProfile%\desktop"
    set fname="%number%的平方根的结果%info%.txt"
    rem 若存在同名文件，获取权限
    if exist %fname% takeown %fname%
    
    >%fname% (
        echo %number%的平方根的结果：
        echo %info%：
        echo （未对其结果进行四舍五入）：
        echo %result%
    )
    goto exit

:exit
    cls
    echo.&echo 保存完毕。
    echo 请选择接下来的操作。
    echo --------------------------
    echo 0：退出
    echo 1：返回重新计算
    echo 2：打开保存到的文件并退出
    echo --------------------------
    set "choice="
    set /p "choice=请输入操作序号，然后按回车键："
    if "%choice%"=="0" exit /b
    if "%choice%"=="1" (
        cls
        goto start
    )
    if "%choice%"=="2" (
        start /d "%windir%" notepad.exe "%UserProfile%\desktop\%number%的平方根的结果%temp%.txt"
        exit /b
    )
    goto exit
    
:StringLength
    set theString=%~1
    if not defined theString goto :eof
    set len=0
    goto StringLength_continue

:StringLength_continue
    set /a len+=1
    set thestring=%thestring:~0,-1%
    if defined thestring goto StringLength_continue
    if not "%2"=="" set %2=!len!
    goto :eof
