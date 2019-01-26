@echo off
rem bignum plus by 523066680
setlocal enabledelayedexpansion

:init
    rem �������ڼ����ַ������ȵ�ģ�壬��������Ϊ 2^pow
    set "sharp=#"
    set unit=1000
    set mask=a987654321
    set /a pow=11, maxlen=1^<^<pow
    for /l %%a in (1,1,%pow%) do set sharp=!sharp!!sharp!

set num_a=1000000000
set num_b=999999999
for /l %%a in (1,1,2000) do set num_a=!num_a!1
for /l %%a in (1,1,2000) do set num_b=!num_b!2
call :check_first %num_a%-%num_b%

call :length %num_a% len_a
call :length %num_b% len_b
call :bignum_minus_opt %num_a% %num_b% %len_a% %len_b% delta
echo %delta%
exit

:check_first
    perl -Mbignum -le "print %1" 2>nul
    goto :eof

::�˺���������� a > b
:bignum_minus_opt
    setlocal
    set num_a=%1
    set num_b=%2
    set /a len_a=%3, len_b=%4, max=len_a, zero=0
    set time_a=%time%

    set /a minus = 0, actlen = 0, left = len_a %% 3, bid = 0
    rem num_bǰ�ò�0������ͳһ����
    set fill=!sharp:~0,%dtlen%!
    set num_b=!fill:#=0!!num_b!

    for /l %%a in ( 3, 3, %len_a% ) do (
        set /a dt = 1!num_a:~-%%a,3! - 1!num_b:~-%%a,3! + minus, bid+=1
        if !dt! lss 0 (
            set /a buff[!bid!] = unit+dt, v=unit+dt, minus=-1
        ) else (
            set /a buff[!bid!] = dt, v = dt, minus=0
        )
        if !v! equ 0 (set /a zero+=1) else (set /a zero=0)
    )

    set "res="
    if %zero% lss %bid% (set /a bid-=zero)
    set /a bid-=1
    for /l %%a in (%bid%, -1, 1) do (
        set /a v = unit + buff[%%a]
        set res=!res!!v:~1!
    )
    ::��λֱ��д�룬����Ҫ����ǰ��0����
    set /a bid+=1
    set res=!res!!buff[%bid%]!

    call :time_delta %time_a% %time% tu
    echo time used: %tu%
    endlocal &set %5=%res%
    goto :eof

::�ַ������ȼ���
:length %str% %vname%
    setlocal
    set test=%~1_%sharp%
    set test=!test:~0,%maxlen%!
    set test=%test:*_=%
    set /a len=maxlen-(%test:#=1+%1)
    endlocal &set %2=%len%
    goto :eof

:: plp626��ʱ���� ʱ������1�����ڿɵ���֮�����ڲ���һ��bat����ʱ��
:time_delta <beginTimeVar> <endTimeVar> <retVar> // code by plp626
    setlocal
    set ta=%1&set tb=%2
    set /a "c=1!tb:~-5,2!!tb:~-2!-1!ta:~-5,2!!ta:~-2!,c+=-6000*(c>>31)"
    if defined %3 set /a c+=!%3!
    endlocal&set %3=%c%
    goto:eof