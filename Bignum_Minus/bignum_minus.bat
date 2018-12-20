@echo off
rem bignum plus by 523066680
setlocal enabledelayedexpansion

:init
  set mod=
  set /a maxlen=2000, half=maxlen/2
  for /l %%a in (1,1,%half%) do set mod=!mod!##

set num_a=100000
set num_b=99999
rem for /l %%a in (1,1,500) do set num_a=!num_a!1
call :bignum_minus %num_a% %num_b% delta
echo %delta%
exit

:bignum_minus
    setlocal
    set num_a=%1
    set num_b=%2
    set time_a=%time%
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
    call :time_used %time_a% %time%
    endlocal &set %3=%delta:#=%
    goto :eof

:length %str% %vname%
    setlocal
    set test=%~1_%mod%
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
    echo time used: %dt:~0,2%.%dt:~2,2%s
    endlocal
    goto :eof

