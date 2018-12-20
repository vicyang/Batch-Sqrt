@echo off
rem bignum plus by 523066680
setlocal enabledelayedexpansion

:init
  set mod=
  set /a maxlen=2000, half=maxlen/2
  for /l %%a in (1,1,%half%) do set mod=!mod!##

set num_a=18
set num_b=2
rem for /l %%a in (1,1,250) do set num_a=!num_a!1
rem for /l %%a in (1,1,250) do set num_b=!num_b!1
rem set /a test = num_a + num_b
call :bignum_div_single %num_a% %num_b% quotient
echo %quotient%
exit

:bignum_div_single
    setlocal
    set time_a=%time%
    set num_a=%1
    set num_b=%2
    call :length %num_a% len_a
    set /a max = len_a
    for /l %%n in ( 1, 1, %max% ) do (
        set /a e = !num_a:~-%%n,1!
    )

    if "!buff[%next%]!" gtr "0" set /a max+=1
    for /l %%a in (%max%, -1, 1) do set /p inp="!buff[%%a]!"<nul
    call :time_used %time_a% %time%
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
    echo %ta% %tb%, time used: %dt:~0,2%.%dt:~2,2%s
    endlocal
    goto :eof

