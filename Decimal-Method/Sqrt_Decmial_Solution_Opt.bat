:: Bignum(Float) Square Root, Decimal Solution
:: https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Decimal_(base_10)
:: 523066680/vicyang
:: 2019-01

@echo off
setlocal enabledelayedexpansion
:init
    rem �������ڼ����ַ������ȵ�ģ�壬��������Ϊ 2^pow
    set "sharp=#"
    set UNIT=100000000
    set ULEN=8
    set mask=a987654321
    set /a pow=11, maxlen=1^<^<pow
    for /l %%a in (1,1,%pow%) do set sharp=!sharp!!sharp!

set precision=150
call :check_one 2
rem call :check_all
exit /b

:: ��������
:check_one
    set ta=!time!
    call :check_first %1 !precision!
    call :decimal_solution %1
    call :time_delta !ta! !time! tu
    echo time used: !tu!
    goto :eof

:: ��������
:check_all
    for /l %%a in (1,1,99) do (
        echo test number: %%a.%%a
        call :check_first %%a.%%a !precision!
        call :decimal_solution %%a.%%a
        echo,
    )
    goto :eof

:: ʹ����������У��/�ԱȽ��
:check_first
    perl -Mbignum=p,-%2 -le "print sqrt(%1)" 2>nul
    goto :eof

:: ���㿪������
:decimal_solution
    setlocal
    set num=%1
    :: Part A, Part B
    if "%num:.=%" == "%num%" set num=%num%.0
    set PA=%num:.=&set PB=%

    :: ���㳤�ȣ��ж���Ҫ��ȡ��Ŀ�곤�ȣ�1 or 2��
    call :length %PA% lenA
    call :length %PB% lenB
    set /a mod=lenA %% 2, skip = 2 - mod
    set /a mod=lenB %% 2
    if %mod% == 1 set PB=!PB!0
    set target=!PA:~0,%skip%!
    set PA=!PA:~%skip%!
    set base=0

    :: prec ��ǰ����
    set /a prec = 0, base_len=0, target_len=skip
    :dec_loop
        :: ������һ����
        :estimate
            :: ��� base == 0�����ܵ����ص��� 0
            if "%base%" == "0" (set /a tbase=0, tbase_len=1
                        ) else (set /a tbase_len=base_len+1 &set tbase=!base!0)
            :: ���Ŀ��ֵ С�� %base%0����һ�������ж�Ϊ0
            call :cmp %target% %tbase% %target_len% %tbase_len% cmp
            if !cmp! equ -1 (
                set /a mid=0, mp=0, mplen=0
                goto :out_estimate
            )

            if %base_len% gtr 5 (
                set /a est=!target:~0,6!/!base:~0,5!
            ) else (
                :: ��set/a���㷶Χ�ڵģ�[�ֱ�]����
                for /l %%a in (0,1,10) do (
                    set /a mp=^(base*10+%%a^)*%%a
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
            if "%base%" == "0" (set /a tbase=mid, tbase_len=1
                        ) else (set /a tbase_len=base_len+1 &set tbase=!base!!mid!)

            if %mid% equ 0 (
                set /a mp=0,mplen=1
            ) else if %mid% equ 1 (
                set mp=!tbase!
                set /a mplen=tbase_len
            ) else (
                call :bignum_mp_single_opt !tbase! !mid! !tbase_len! 1 mp mplen
                rem echo, &echo !tbase! !mid! !mp! !mplen!
            )

            call :cmp !mp! !target! !mplen! !target_len! cmp
            :: ���mp����Ŀ�귶Χ
            if !cmp! equ 1 (
                set /a mid-=1
                call :bignum_mp_single_opt !base!!mid! !mid! !base_len!+1 1 mp mplen
            )
        :out_estimate

        set /p inp="%mid%"<nul
        rem echo,&echo tg !target!, mp !mp!, base !base!, mid !mid!, est !est!
        if "%PA%" == "" (
            if %lenB% equ 0 (
                :: ���targetֻʣ�� 0����������
                if "%target%" == "0" ( goto :dec_loop_out )
                if %cmp% == 0 ( goto :dec_loop_out )
            )
        )

        :: ������һ��target��ֵ
        rem echo,&echo before !target! !mp!
        call :bignum_minus_opt %target% %mp% %target_len% %mplen% target target_len
        rem echo aftertg !target! tglen !target_len!

        :: ����target��������������Ѿ���ȡ�ֱ꣬�Ӳ�0������+1
        if %skip% geq %lenA% (
            if !lenB! gtr 0 (
                set /a lenA=lenB, skip=2, lenB=0
                set target=!target!!PB:~0,2!
                set PA=!PB:~2!
            ) else (
                set target=%target%00
            )
        ) else (
            if "%target%" == "0" (set target=!PA:~0,2!
                          ) else (set target=!target!!PA:~0,2!)
            set PA=!PA:~2!
            set /a skip+=2
        )

        call :length %target% target_len
        :zero
        if "%target%" == "0" goto :out_zero
        if "%target:~0,1%" == "0" (set /a target_len-=1&set target=!target:~1!&goto :zero)
        :out_zero

        :: �������С������׶�
        if %lenB% equ 0 (
            set /a prec+=1
            if !prec! equ 1 set /p inp="."<nul
        )

        :: ���»��� - base
        rem base=base*10+mid*2
        if "%base%" == "0" (
            set /a base=mid*2, base_len=1+base/10
        ) else (
            set /a db_mid=mid*2, dbmidlen=1+db_mid/10, base_len+=1
            if !db_mid! gtr 9 (
                set /a plus=!base:~-1,1!+1
                set base=!base:~0,-1!!plus!!db_mid:~1!
            ) else (
                set base=!base!!db_mid!
            )
        )

    rem echo - %prec%
    if %prec% leq %precision% (goto :dec_loop)
    :dec_loop_out
    echo,
    endlocal
    goto :eof

:: �Ƚ�
:cmp
    set /a La=%3, Lb=%4
    if %La% gtr %Lb% (set /a %5=1&goto :eof)
    if %La% lss %Lb% (set /a %5=-1&goto :eof)
    :: ���������ͬ��ֱ�Ӱ��ַ����Ա�
    if "%1" gtr "%2" (set /a %5=1&goto :eof)
    if "%1" lss "%2" (set /a %5=-1&goto :eof)
    if "%1" equ "%2" (set /a %5=0&goto :eof)

:: ���� ���� ��λ��
:bignum_mp_single_opt
    setlocal
    set num_a=%1
    set num_b=%2
    if "%num_b%" == "0" (endlocal&set %5=0&set %6=1&goto :eof)
    set /a len_a=%3
    rem actlen ��ʵ�ʳ��ȣ�bid���������鳤��
    set /a pool = 0, actlen = 0, left = len_a %% 8, bid = 0

    set "res="
    for /l %%a in ( 8, 8, %len_a% ) do (
        set /a ele=1!num_a:~-%%a,8! - UNIT
        set /a mp = !ele! * num_b + pool, actlen+=8, bid+=1
        set /a value = mp %% UNIT + UNIT, pool = mp / UNIT
        set res=!value:~1!!res!
    )

    ::����������ֶΣ�����ʣ���ֶ�������Ϊ7λ��*9���8λ��
    if %left% gtr 0 (
        set /a mp = !num_a:~0,%left%!*num_b + pool, pool = mp/UNIT
        set mpmask=!mp!!mask!
        set /a actlen+=0x!mpmask:~10,1!
        set res=!mp!!res!
    ) else (
        rem ��������ֶ���գ����Ǹ��ֶθպý�һλ�����
        if %pool% gtr 0 (
            set res=!pool!!res!
            set /a actlen+=1
        )
    )
    endlocal&set %5=%res%&set %6=%actlen%
    goto :eof

::�˺���������� a > b
:bignum_minus_opt
    setlocal
    set num_a=%1
    set num_b=%2
    set /a len_a=%3, len_b=%4, max=len_a, dtlen=len_a-len_b, zero=0
    if %len_a% leq 8 (
        set /a dt=%1-%2
        set mimask=!dt!!mask!
        set /a actlen=0x!mimask:~10,1!
    )
    if %len_a% leq 8 (endlocal&set %5=%dt%&set %6=%actlen%&goto :eof)

    set /a minus = 0, actlen = 0, left = len_a %% 8, bid = 0
    rem num_bǰ�ò�0������ͳһ����
    if %dtlen% gtr 0 (
        set fill=!sharp:~0,%dtlen%!
        set num_b=!fill:#=0!!num_b!
    )

    for /l %%a in ( 8, 8, %len_a% ) do (
        set /a dt = 1!num_a:~-%%a,%ULEN%! - 1!num_b:~-%%a,%ULEN%! + minus, bid+=1
        if !dt! lss 0 (
            set /a buff[!bid!] = UNIT+dt, v=UNIT+dt, minus=-1
        ) else (
            set /a buff[!bid!] = dt, v = dt, minus=0
        )
        if !v! equ 0 (set /a zero+=1) else (set /a zero=0)
    )

    if %left% gtr 0 (
        set /a dt = 1!num_a:~0,%left%!-1!num_b:~0,%left%! + minus
        if !dt! neq 0 (
            set /a bid+=1
            set /a buff[!bid!]=dt
        )
    )

    rem echo !bid! !zero!
    set "res="
    if %zero% lss %bid% (set /a bid-=zero)
    set /a bid-=1, actlen=0
    for /l %%a in (%bid%, -1, 1) do (
        set /a v = UNIT + buff[%%a], actlen+=8
        set res=!res!!v:~1!
    )

    ::��λֱ��д�룬����Ҫ����ǰ��0����
    set /a bid+=1
    set res=!buff[%bid%]!!res!
    set mimask=!buff[%bid%]!!mask!
    set /a actlen+=0x!mimask:~10,1!

    endlocal &set %5=%res%&set %6=%actlen%
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
