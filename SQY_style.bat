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

:start
    echo.&echo �����뱻������������������,Ȼ�󰴻س�����
    echo �������������Ϊ2147483646��������Χ����������
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
    echo.&echo �����뾫ȷλ��,Ȼ�󰴻س�����
    echo ��ָ��ȷ��С�����ڼ�λ��
    echo ���ó��򲻻�����һλ�����������룩
    echo ����ȷλ�����Ϊ238609294��������Χ����������
    echo �����ڽ��Ϊ�����ģ��������ȥС�����֣�
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
    goto then

:error_e
    cls
    color fc
    echo ���󣺾�ȷλ�����ܴ���238609294�����������룡
    echo.&echo �������������&pause>nul
    color f0
    cls
    goto then

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
    echo.&echo ������ϣ�
    echo.%TIMEA%
    echo.%time%
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
    if "%choice%"=="2" goto exit_one
    goto end

:exit_one
    if "%bit%"=="0" (
        set temp=������������
    ) else (
        set temp=����ȷ��С������%bit%λ��
    )
    cd /d "%UserProfile%\desktop"
    if exist "%number%��ƽ�����Ľ��%temp%.txt" (
        takeown "%number%��ƽ�����Ľ��%temp%.txt"
        del /f /s /q "%number%��ƽ�����Ľ��%temp%.txt"
    )
    echo %number%��ƽ�����Ľ����>>%number%��ƽ�����Ľ��%temp%.txt
    echo %temp%��>>%number%��ƽ�����Ľ��%temp%.txt
    echo ��δ�����������������룩��>>%number%��ƽ�����Ľ��%temp%.txt
    echo %nun% >>%number%��ƽ�����Ľ��%temp%.txt
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