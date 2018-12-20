@echo off
setlocal enabledelayedexpansion

:init
  rem static template for calculating strlen
  set "mod=" &set /a maxlen=2000, half=maxlen/2
  for /l %%a in (1,1,%half%) do set mod=!mod!##

set num_a=56
set num_b=99
rem set num_a=1234569999999999999999999999999999999999999999999999999999999999999999999999999
rem set num_b=9999999999999999999999999999999999999999999999999999999999999999999999999999999

rem set num_a=100
rem set num_b=1000
call :bignum_mp %num_a% %num_b% product
echo %product%
exit

:bignum_mp
    setlocal
    set time_a=%time%
    set num_a=%1
    set num_b=%2
    call :length %num_a% len_a
    call :length %num_b% len_b
    for /l %%b in ( 1, 1, %len_b% ) do ( set ele_b=!ele_b! !num_b:~-%%b,1! )
    for /l %%a in ( 1, 1, %len_a% ) do ( set ele_a=!ele_a! !num_a:~-%%a,1! )
    rem for /l %%a in (0, 1, %attemplen%) do set buff[%%a]=0
    set /a id = 0, sid = 0, maxid = 0, pool = 0
    for %%b in ( %ele_b% ) do (
        set /a sid = id, id += 1
        for %%a in ( %ele_a% ) do (
            set /a val = %%a * %%b + pool
            if !val! geq 10 (
                set /a foo = val/10, bar = val %% 10
                set /a buff[!sid!] = bar, pool = foo, ^
                        sid += 1, maxid = sid
            ) else (
                set /a buff[!sid!] = val, pool = 0, sid += 1, maxid = sid 
            )
        )
    )

    if "!buff[%maxid%]!" == "0" set /a maxid-=1
    set product=
    for /l %%n in (%maxid%, -1, 0) do set product=!product!!buff[%%n]!
    call :time_used %time_a% %time%
    endlocal &set %3=%product%
    goto :eof
    
:length %str% %vname%
    setlocal
    set test=%1_%mod%
    set test=!test:~0,%maxlen%!
    set test=%test:*_=%
    set /a len=maxlen-(%test:#=1+%1)
    endlocal &set %2=%len%
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
    echo %ta% %tb%, time used: %dt:~0,2%.%dt:~2,2%s
    endlocal
    goto :eof