@echo off
setlocal enabledelayedexpansion

set start=yes
set number=2
set bit=3
set u=0
set tga=0
call :stringlength "%number%" len
set /a allbit=(%len%+1)/2
set num=%allbit%
set tgb=%num%
set /a num+=1
for /l %%i in (0 1 %num%) do (set js[%%i]=0)
set kfmain=js[1]
call :kfmain
pause
exit


:kfmain
    set /a u+=1
    rem 设置常量映射表
    set ER_2m=1
    set ER_5m=2
    set ER_4m=3
    set ER_2l=4
    set U_1=5
    set ER_7m=6
    set ER_5l=7
    set ER_9m=8
    set ER_7l=9
    
    if defined ER_%er% (
        set %kfmain%=!ER_%er%!
        goto bignum_mp
    )
    
    if defined U_%u% (
        set %kfmain%=!U_%u%!
        goto bignum_mp
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


:bignum_mp
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
    echo !dg[0]! !dg[1]! !dg[2]!
    echo !js[0]! !js[1]! !js[2]!
    pause
    
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
