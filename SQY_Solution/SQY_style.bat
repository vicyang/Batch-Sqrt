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

:start
    echo.&echo 请输入被开方数（仅限整数）,然后按回车键：
    echo （被开方数最高为2147483646，超出范围，会计算出错）
    set number=
    set /p "number="
    goto next

:next
    cls
    if "%number%"=="" goto start
    set /a temp=%number%+0
    if not "%temp%"=="%number%" goto error_a
    if not %number% geq 0 goto error_b
    if %number% geq 2147483647 goto error_c
    goto then

:then
    cls
    echo.&echo 请输入精确位数,然后按回车键：
    echo （指精确到小数点后第几位）
    echo （该程序不会对最后一位进行四舍五入）
    echo （精确位数最高为238609294，超出范围，会计算出错）
    echo （对于结果为整数的，程序会舍去小数部分）
    set bit=
    set /p "bit="
    goto other

:other
    cls
    if "%bit%"=="" goto then
    set /a temp=%bit%+0
    if not "%bit%"=="%temp%" goto error_d
    if not %bit% geq 0 goto error_d
    if %bit% geq 238609295 goto error_e
    set start=yes
    goto main

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
    goto then

:error_e
    cls
    color fc
    echo 错误：精确位数不能大于238609294，请重新输入！
    echo.&echo 按任意键继续：&pause>nul
    color f0
    cls
    goto then

:main
    cls
    echo.&echo  已经开始计算。
    echo  每计算一位，都会对结果更新！
    echo  越往后计算，结果显示越慢！请耐心等待本程序计算完成。
    echo.&echo 被开方数：%number%
    if not "%start%"=="yes" (
        set /a num+=1
        set /a tga=!num!-%allbit%-1
        set /a temp=!tga!%%4
        if not "!tga!"=="1" (
            if "!temp!"=="1" (
                set nun=%nun%^ %main:~-1%
            ) else (
                set nun=%nun%%main:~-1%
            )
        ) else (
            set nun=%nun%%main:~-1%
        )
        set /a temp=%tga%+1
        if "!temp!"=="%bit%" goto end
        echo.&echo 计算结果（未对其结果进行四舍五入）：
        echo.&echo %nun%
        goto js
    ) else (
        echo.&echo 请稍候…… 
        goto temp
    )

:temp
    set u=0
    set tga=0
    call :stringlenth "%number%" num
    set /a allbit=(%num%+1)/2
    set num=%allbit%
    set tgb=%num%
    set /a num+=1
    for /l %%i in (0 1 %num%) do set js[%%i]=0
    if "%allbit%"=="1" (
        set kfmain=js[1]
        call :kfmain
    ) else (
        for /l %%i in (%tgb% -1 1) do (
            set u=0
            set kfmain=js[%%i]
            call :kfmain
            set js[%%i]=!temp!
        )
        set temp=
        for /l %%i in (%tgb% -1 1) do (
            set temp=!temp!!js[%%i]!
        )
    )
    set all=%temp%
    set /a temp=%all%*%all%
    if "%temp%"=="%number%" (
        set bit=0
        set nun=%all%
        goto end
    )
    if "%bit%"=="0" (
        set nun=%all%
        goto end
    )
    set "main=%all%."
    set "nun=%all%."
    set start=no
    goto js

:js
    set "nmn=%main:.=%"
    set /a tgb=%num%-1
    set kfmain=js[0]
    if "%tgb%"=="1" (
        set js[1]=%nmn%
    ) else (
        for /l %%i in (%tgb% -1 1) do (
            set temp=!nmn:~-%%i!
            set js[%%i]=!temp:~0,1!
        )
    )
    set js[%num%]=0
    set u=0
    call :kfmain
    set main=%main%%temp%
    goto main

:end
    cls
    echo.&echo 计算完毕！
    echo.%TIMEA%
    echo.%time%
    echo.&echo 被开方数：%number%
    echo.&echo 计算结果（未对其结果进行四舍五入）：
    echo !nun!
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
    if "%choice%"=="2" goto exit_one
    goto end

:exit_one
    if "%bit%"=="0" (
        set temp=（保留整数）
    ) else (
        set temp=（精确到小数点后第%bit%位）
    )
    cd /d "%UserProfile%\desktop"
    if exist "%number%的平方根的结果%temp%.txt" (
        takeown "%number%的平方根的结果%temp%.txt"
        del /f /s /q "%number%的平方根的结果%temp%.txt"
    )
    echo %number%的平方根的结果：>>%number%的平方根的结果%temp%.txt
    echo %temp%：>>%number%的平方根的结果%temp%.txt
    echo （未对其结果进行四舍五入）：>>%number%的平方根的结果%temp%.txt
    echo %nun% >>%number%的平方根的结果%temp%.txt
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

:kfmain
    set /a u+=1
    if "%er%"=="2m" (
        set %kfmain%=1
        goto jsmain
    )
    if "%er%"=="5m" (
        set %kfmain%=2
        goto jsmain
    )
    if "%er%"=="4m" (
        set %kfmain%=3
        goto jsmain
    )
    if "%er%"=="2l" (
        set %kfmain%=4
        goto jsmain
    )
    if "%u%"=="1" (
        set %kfmain%=5
        goto jsmain
    )
    if "%er%"=="7m" (
        set %kfmain%=6
        goto jsmain
    )
    if "%er%"=="5l" (
        set %kfmain%=7
        goto jsmain
    )
    if "%er%"=="9m" (
        set %kfmain%=8
        goto jsmain
    )
    if "%er%"=="7l" (
        set %kfmain%=9
        goto jsmain
    )
    if "%er%"=="1m" set temp=0
    if "%er%"=="1l" set temp=1
    if "%er%"=="3m" set temp=2
    if "%er%"=="3l" set temp=3
    if "%er%"=="4l" set temp=4
    if "%er%"=="6m" set temp=5
    if "%er%"=="6l" set temp=6
    if "%er%"=="8m" set temp=7
    if "%er%"=="8l" set temp=8
    if "%er%"=="9l" set temp=9
    goto :eof

:jsmain
    set tgc=0
    set /a tgd=%num%*2-1
    for /l %%i in (%tgd% -1 0) do set dg[%%i]=0
    for /l %%i in (0 1 %tgb%) do (
        for /l %%r in (0 1 %num%) do (
            set /a i=%%i+%%r
            set /a temp=!js[%%i]!*!js[%%r]!+!tgc!
            set /a dg[!i!]+=!temp!%%10
            set /a tgc=!temp!/10
        )
        set tgc=0
        if %tga% geq 50 (
            if %tga% geq 100 (
                set /p=<nul
                set /p=总进度^:%u%^(最少3^,最多4^)^,副进度^:%%i^(共%tgb%^)^ ^ ^ ^ <nul
            ) else (
                set /p=<nul
                set /p=总进度^:%u%^(最少3^,最多4^)^ ^ ^ ^ <nul
            )
        )
    )
    
    set /a tgd-=1
    for /l %%i in (0 1 %tgd%) do (
        set /a temp=%%i+1
        set /a dg[!temp!]+=!dg[%%i]!/10
    )
    
    set /a tgd+=1
    set /a tge=1+!tgd!-(%allbit%*2)
    set tgf=
    for /l %%i in (!tgd! -1 !tge!) do (
        set /a temp=!dg[%%i]!%%10
        if "%%i"=="!tgd!" (
            if not "!temp!"=="0" (
                set tgf=!temp!
            )
        ) else (
            set tgf=!tgf!!temp!
        )
    )
    
    if not "%start%"=="yes" (
        if !tgf! geq %number% (
            set er=!%kfmain%!m
        ) else (
            set er=!%kfmain%!l
        )
    ) else (
        if !tgf! gtr %number% (
            set er=!%kfmain%!m
        ) else (
            set er=!%kfmain%!l
        )
    )
    goto kfmain

:StringLenth
    set theString=%~1
    if not defined theString goto :eof
    set temp=0
    goto StringLenth_continue

:StringLenth_continue
    set /a temp+=1
    set thestring=%thestring:~0,-1%
    if defined thestring goto StringLenth_continue
    if not "%2"=="" set %2=!temp!
    goto :eof