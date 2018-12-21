:: Bignum(integer) Square Root
:: 523066680/vicyang
:: 2018-12

@echo off
setlocal enabledelayedexpansion
:init
    rem template for counting string length
    set mod=
    set /a maxlen=2000, half=maxlen/2
    for /l %%a in (1,1,%half%) do set mod=!mod!##
    set time_a=%time%

set num=123456787654322
rem set num=10
set time_a=%time%
set main_ta=%time%
call :get_int_of_root %num% int_root cmp
call :time_delta %time_a% %time% ir_tu
echo int_root_tu = %ir_tu%
if %cmp% equ 0 (
    set root=%int_root%
    echo num = %num%, root = !root!, !cmp!
    exit /b
)

set precision=25
call :check_first %num% %precision%
call :get_dec_of_root %num% %int_root% %precision% dec_root
call :time_used %main_ta% %time%
exit /b

:check_first
    perl -Mbignum=a,100 -le "printf qq(%%s\n), sqrt(%1)" 2>nul
    goto :eof

:get_dec_of_root
    setlocal
    set num=%1
    set int_root=%2
    set precision=%3
    set root=%int_root%
    rem Show int_root first
    set /p inp="%int_root%."<nul
    call :bignum_mp %root% %root% prev_pow

    set /a dec_len=0
    :decroot_lp
        set /a min=0, max=10, mid=(max+min)/2, quit = 0, dec_len+=1
        :decroot_bin_search
            rem calc [a*10]^2 + 2*[a*10]*b + b^2, part1 part2 part3
            set /a sum = 0
            set part1=%prev_pow%00
            set /a part3 = mid * mid
            set /a double_mid = mid * 2

            set time_a=%time%
            call :bignum_mp %root%0 %double_mid% part2
            call :time_delta %time_a% %time% mp_tu

            set time_a=%time%
            call :bignum_plus %part1% %part2% sum
            call :bignum_plus %sum% %part3% sum
            call :time_delta %time_a% %time% plus_tu

            rem compare
            set time_a=%time%
            call :cmp %sum% %num%00 cmp
            call :time_delta %time_a% %time% cmp_tu
            rem echo %root%%mid% %sum% %num%00 min:%min% max:%max% %cmp% 
            set /a range=max-min
            if %cmp% gtr 0 ( set /a max=mid )
            if %cmp% lss 0 ( set /a min=mid )
            if %cmp% equ 0 ( set /a quit=1 )
            if %range% leq 1 ( set /a quit=1 )
            set /a mid=(max+min)/2
            
        if %quit% equ 0 goto :decroot_bin_search
        set prev_pow=%sum%
        set root=%root%%mid%
        set num=%num%00
        set /p inp="%mid%"<nul
    if %dec_len% lss %precision% goto :decroot_lp
    echo,
    echo mp_tu = %mp_tu%, plus_tu = %plus_tu%, cmp_tu = %cmp_tu%
    endlocal
    goto :eof

:get_int_of_root
    rem get the integer part of root
    setlocal
    set num=%1
    call :length %num% len
    rem initial min and max number
    set /a min = 1, max = 10, root_len = len / 2 + len %% 2
    for /l %%n in (2,1,%root_len%) do (set min=!min!0& set max=!max!9)
    call :bignum_plus %min% %max% sum
    rem middle_number = sum / 2
    call :bignum_div_single %sum% 2 mid
    
    set /a quit = 0
    :binary_search
        call :bignum_mp %mid% %mid% product
        call :cmp %product% %num% cmp
        call :bignum_minus %max% %min% range

        if !cmp! equ 0 (
            set /a quit = 1, cmp=0
        ) else (
            if !cmp! gtr 0 (
                set max=!mid!
                set cmp=1
            )   
            if !cmp! lss 0 ( 
                set min=!mid!
                set cmp=-1
            )
            call :bignum_plus !max! !min! sum
            call :bignum_div_single !sum! 2 mid
            rem Using !var!, because we are inside the brackets
        )
        if %range% leq 1 (set quit=1)
    if %quit% == 0 goto :binary_search
    endlocal &set %2=%mid%& set %3=%cmp%
    goto :eof

:bignum_mp
    setlocal
    set num_a=%1
    set num_b=%2
    call :length %num_a% len_a
    call :length %num_b% len_b
    for /l %%b in ( 1, 1, %len_b% ) do ( set ele_b=!ele_b! !num_b:~-%%b,1! )
    for /l %%a in ( 1, 1, %len_a% ) do ( set ele_a=!ele_a! !num_a:~-%%a,1! )
    rem for /l %%a in (0, 1, %attemplen%) do set buff[%%a]=0
    set /a id = 0, sid = 0, maxid = 0
    for %%b in ( %ele_b% ) do (
        set /a sid = id, id += 1
        for %%a in ( %ele_a% ) do (
            set /a buff[!sid!] += %%a * %%b, sid += 1, maxid = sid
        )
    )
    rem Merge
    set /a id = 0
    for /l %%c in ( 0, 1, %maxid% ) do (
        set /a next = %%c+1
        set /a buff[!next!] += buff[%%c]/10, buff[%%c] = buff[%%c] %% 10
    )

    if "!buff[%maxid%]!" == "0" set /a maxid-=1
    set product=
    for /l %%n in (%maxid%, -1, 0) do set product=!product!!buff[%%n]!
    endlocal &set %3=%product%
    goto :eof

:bignum_plus
    setlocal
    set num_a=%1
    set num_b=%2
    call :length %num_a% len_a
    call :length %num_b% len_b
    set /a max = len_a
    if %len_b% gtr %len_a% (set /a max=len_b, len_b=len_a&set num_a=%num_b%&set num_b=%num_a%)

    for /l %%n in ( 1, 1, %max% ) do (
        if %%n leq %len_b% (
            set /a buff[%%n] = !num_a:~-%%n,1! + !num_b:~-%%n,1!
        ) else (
            set buff[%%n]=!num_a:~-%%n,1!
        )
    )

    set /a id = 0
    for /l %%c in ( 0, 1, %max% ) do (
        set /a next = %%c+1
        set /a buff[!next!] += buff[%%c]/10, buff[%%c] = buff[%%c] %% 10
    )

    if "!buff[%next%]!" gtr "0" set /a max+=1
    set sum=
    for /l %%a in (%max%, -1, 1) do set sum=!sum!!buff[%%a]!
    endlocal &set %3=%sum%
    goto :eof

:bignum_minus
    setlocal
    set num_a=%1
    set num_b=%2
    call :length %num_a% len_a
    call :length %num_b% len_b
    set /a max = len_a
    if %len_b% gtr %len_a% (set /a max=len_b, len_b=len_a&set num_a=%num_b%&set num_b=%num_a%)

    set /a minus = 0
    for /l %%n in ( 1, 1, %max% ) do (
        if %%n leq %len_b% (
            set /a dt = !num_a:~-%%n,1! - !num_b:~-%%n,1! - minus
        ) else (
            set /a dt = !num_a:~-%%n,1! - minus
        )
        if !dt! lss 0 (
            set /a buff[%%n] = dt + 10, minus=1
        ) else (
            set /a buff[%%n] = dt, minus=0
        )
    )

    set delta=#
    for /l %%a in (%max%, -1, 1) do set delta=!delta:#0=#!!buff[%%a]!
    endlocal &set %3=%delta:#=%
    goto :eof

:bignum_div_single
    setlocal
    set num_a=%1
    set num_b=%2
    call :length %num_a% len_a
    set /a max = len_a, mod = 0
    for /l %%n in ( %len_a%, -1, 1 ) do (
        set /a e = !num_a:~-%%n,1! + mod*10
        set /a buff[%%n] = e/num_b, mod = e %% num_b
    )
    if !buff[%max%]! == 0 (set /a max-=1)

    set quotaint=
    for /l %%a in (%max%, -1, 1) do set quotaint=!quotaint!!buff[%%a]!
    endlocal &set %3=%quotaint%
    goto :eof

:length %str% %vname%
    setlocal
    set test=%~1_%mod%
    set test=!test:~0,%maxlen%!
    set test=%test:*_=%
    set /a len=maxlen-(%test:#=1+%1)
    endlocal &set %2=%len%
    goto :eof

:cmp %str1% %str2% %vname%
    setlocal
    call :length %1 len_a
    call :length %2 len_b
    if %len_a% gtr %len_b% (endlocal &set %3=1&goto :eof)
    if %len_a% lss %len_b% (endlocal &set %3=-1&goto :eof)
    set str1=%1
    set str2=%2
    if %len_a% equ %len_b% (
        for /l %%n in (0, 1, %len_a%) do (
            if "!str1:~%%n,1!" gtr "!str2:~%%n,1!" (endlocal &set %3=1&goto :eof)
            if "!str1:~%%n,1!" lss "!str2:~%%n,1!" (endlocal &set %3=-1&goto :eof)
        )
        endlocal &set %3=0
    )
    goto :eof

:time_used %time_a% %time_b%
    rem only for few seconds, not consider minutes
    setlocal
    set ta=%1& set tb=%2
    rem insert 1 befeore 00.00 if first num is zero
    set ta=1%ta:~-5%
    set tb=1%tb:~-5%
    set /a dt = %tb:.=% - %ta:.=%
    set dt=%dt:-=%
    set dt=0000%dt%
    set dt=%dt:~-4%
    echo time used: %dt:~0,2%.%dt:~2,2%s
    endlocal
    goto :eof

:time_delta %time_a% %time_b% %var_name%
    setlocal
    set ta=%1& set tb=%2
    rem 前置数字1避免前置0被识别为八进制
    set sec_a=1%ta:~-5,2%
    set sec_b=1%tb:~-5,2%
    set dec_a=1%ta:~-2%
    set dec_b=1%tb:~-2%
    set /a dec=dec_b-dec_a, sec=sec_b-sec_a
    rem 秒数取绝对值
    set sec=%sec:-=%
    rem echo %sec% %dec% 
    if %dec% lss 0 (set /a sec-=1, dec=100+dec_b-dec_a)
    rem echo %sec% %dec% 
    set /a t_used=sec*100+dec
    if defined %3 set /a t_used += %3
    endlocal&set %3=%t_used%
    goto :eof


