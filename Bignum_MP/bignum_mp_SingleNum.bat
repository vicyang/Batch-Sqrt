@echo off
setlocal enabledelayedexpansion

:init
  rem static template for calculating strlen
  set "mod="
  set /a maxlen = 2000, half = maxlen/2
  for /l %%a in (1,1,%half%) do set mod=!mod!##

set num_a=2
set num_b=9

for /l %%a in (1,1,1000) do (set num_a=!num_a!2)

call :bignum_mp_single %num_a% %num_b% product
echo %product%
pause
exit

:bignum_mp_single
    setlocal
    set time_a=%time%
    set num_a=%1
    set num_b=%2
    call :length %num_a% len
    set /a pool = 0, maxid = len
    for /l %%a in ( 1, 1, %len% ) do (
        set /a mp = !num_a:~-%%a,1! * num_b + pool
        if !mp! geq 10 (
            set /a buff[%%a] = mp %% 10, pool = mp / 10
        ) else (
            set /a buff[%%a] = mp
        )
    )

    if %pool% neq 0 (
        set /a maxid+=1
        set /a buff[!maxid!] = pool
    )

    call :time_used %time_a% %time%
    set res=
    for /l %%n in (%maxid%, -1, 0) do set res=!res!!buff[%%n]!
    endlocal&set %3=%res%
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
    set ta=#%ta:~-5%& set tb=#%tb:~-5%
    set ta=%ta:#0=%& set tb=%tb:#0=%
    set ta=%ta:#=%& set tb=%tb:#=%
    set /a dt = %tb:.=% - %ta:.=%
    set dt=%dt:-=%
    set dt=0000%dt%
    set dt=%dt:~-4%
    echo time used: %dt:~0,2%.%dt:~2,2%s
    endlocal
    goto :eof

