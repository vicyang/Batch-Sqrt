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

:start
    echo.&echo �����뱻������������������,Ȼ�󰴻س�����
    echo �������������Ϊ2147483646��������Χ����������
    set number=
    set /p "number="
    goto get_number

:get_number
    cls
    if "%number%"=="" goto start
    set /a temp=%number%+0
    if not "%temp%"=="%number%" goto error_a
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
    cls
    if "%bit%"=="" goto then
    set /a temp=%bit%+0
    if not "%bit%"=="%temp%" goto error_d
    if not %bit% geq 0 goto error_d
    if %bit% geq 238609295 goto error_e
    set start=yes
    goto main

:main
    cls
    echo.&echo  �Ѿ���ʼ���㡣
    echo  ÿ����һλ������Խ�����£�
    echo  Խ������㣬�����ʾԽ���������ĵȴ������������ɡ�
    echo.&echo ����������%number%
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
        echo.&echo ��������δ�����������������룩��
        echo.&echo %nun%
        goto js
    ) else (
        echo.&echo ���Ժ򡭡�
        goto temp
    )

:temp
    set u=0
    set tga=0
    call :stringlength "%number%" len
    set /a allbit=( %len% +1)/2
    set num=%allbit%
    set tgb=%num%
    set /a num+=1
    for /l %%i in (0 1 %num%) do (set js[%%i]=0)
    
    rem ���Ԥ�������������ֻ��1λ
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



:kfmain
    set /a u+=1
    rem ���ó���ӳ���
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

rem ������� bignum multiply
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
                set /p=�ܽ���^:%u%^(����3^,���4^)^,������^:%%i^(��%tgb%^)^ ^ ^ ^ <nul
            ) else (
                set /p=<nul
                set /p=�ܽ���^:%u%^(����3^,���4^)^ ^ ^ ^ <nul
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
    cls
    echo.&echo ������ϣ�
    echo.&echo ����������%number%
    echo.&echo ��������δ�����������������룩��
    echo !nun!
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
        echo %nun%
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
