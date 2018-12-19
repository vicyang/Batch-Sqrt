@echo off
title ��������ƽ������ֵ
color f0
PUSHD %~dp0
cd /d %~dp0
setlocal enabledelayedexpansion
cls
echo ------------------
echo ��������ƽ������ֵ
echo ------------------
set TIMEA=%time%

:init 
    rem ��ʼ������ӳ���
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
    echo.&echo �����뱻������������������,Ȼ�󰴻س�����
    echo �������������Ϊ2147483646��������Χ����������
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
    echo.&echo �����뾫ȷλ��,Ȼ�󰴻س�����
    echo ��ָ��ȷ��С�����ڼ�λ��
    echo ���ó��򲻻�����һλ�����������룩
    echo ����ȷλ�����Ϊ238609294��������Χ����������
    echo �����ڽ��Ϊ�����ģ��������ȥС�����֣�
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
    %echo%.&%echo%  �Ѿ���ʼ���㡣
    %echo%  ÿ����һλ������Խ�����£�
    %echo%  Խ������㣬�����ʾԽ���������ĵȴ������������ɡ�
    %echo%.&%echo% ����������%number%
    if not "%start%"=="yes" (
        set /a num+=1
        set /a dec_bits = num - int_bits - 1
        set /a mod = dec_bits %% 4
        rem С�����ÿ4λ���ֱ���һ���ո�
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
        %echo%.&%echo% ��������δ�����������������룩��
        %echo%.&%echo% %result%
        goto js
    ) else (
        %echo%.&%echo% ���Ժ򡭡�
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
    
    rem �����������ֻ��1λ
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

    rem �������飬Ԥ��1λ
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
                set /p=�ܽ���^:%u%^(����3^,���4^)^,������^:%%i^(��%root_len%^)^ ^ ^ ^ <nul
            ) else (
                set /p=<nul
                set /p=�ܽ���^:%u%^(����3^,���4^)^ ^ ^ ^ <nul
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
    echo ��������ı��������������������������룡
    echo �����ֵ���ó���������֧�ֵ����ֵ��2147483647����
    echo �벻Ҫ������ǰ�������ţ�+���������㣡
    echo.&echo �������������&pause>nul
    color f0
    cls
    goto start

:error_b
    cls
    color fc
    echo ����ƽ�����б�����������С��0�����������룡
    echo.&echo �������������&pause>nul
    color f0
    cls
    goto start

:error_c
    cls
    color fc
    echo ���󣺱����������ܴ���2147483646�����������룡
    echo.&echo �������������&pause>nul
    color f0
    cls
    goto start

:error_d
    cls
    color fc
    echo ��������ľ�ȷλ�����������������������룡
    echo �����ֵ���ó���������֧�ֵ����ֵ��2147483647����
    echo �벻Ҫ������ǰ�������ţ�+���������㣡
    echo.&echo �������������&pause>nul
    color f0
    cls
    goto set_precision

:error_e
    cls
    color fc
    echo ���󣺾�ȷλ�����ܴ���238609294�����������룡
    echo.&echo �������������&pause>nul
    color f0
    cls
    goto set_precision
    
:end
    %cls%
    %echo%.&%echo% ������ϣ�
    rem echo.%TIMEA%
    rem echo.%time%
    echo.&echo ����������%number%
    %echo%.&%echo% ��������δ�����������������룩��
    echo !result!
    if "%test_mode%" == "1" goto :eof
    echo.&echo �������������&pause>nul
    cls
    echo ��ѡ��������Ĳ�����
    echo ---------------------
    echo 0���˳�
    echo 1���������¼���
    echo 2����������������档
    echo ---------------------
    set "choice="
    set /p "choice=�����������ţ�Ȼ�󰴻س�����"
    if "%choice%"=="0" exit /b
    if "%choice%"=="1" (
        cls
        goto start
    )
    if "%choice%"=="2" goto save_and_exit
    goto end

:save_and_exit
    if "%bit%"=="0" (
        set info=������������
    ) else (
        set info=����ȷ��С������%bit%λ��
    )
    cd /d "%UserProfile%\desktop"
    set fname="%number%��ƽ�����Ľ��%info%.txt"
    rem ������ͬ���ļ�����ȡȨ��
    if exist %fname% takeown %fname%
    
    >%fname% (
        echo %number%��ƽ�����Ľ����
        echo %info%��
        echo ��δ�����������������룩��
        echo %result%
    )
    goto exit

:exit
    cls
    echo.&echo ������ϡ�
    echo ��ѡ��������Ĳ�����
    echo --------------------------
    echo 0���˳�
    echo 1���������¼���
    echo 2���򿪱��浽���ļ����˳�
    echo --------------------------
    set "choice="
    set /p "choice=�����������ţ�Ȼ�󰴻س�����"
    if "%choice%"=="0" exit /b
    if "%choice%"=="1" (
        cls
        goto start
    )
    if "%choice%"=="2" (
        start /d "%windir%" notepad.exe "%UserProfile%\desktop\%number%��ƽ�����Ľ��%temp%.txt"
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
