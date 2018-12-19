@echo off
rem bignum plus by 523066680
setlocal enabledelayedexpansion

:init
    rem template for calculating strlen
    rem @ http://bbs.bathome.net/redirect.php?goto=findpost&pid=210336
    set mod=#0#1#2#3#4#5#6#7#8#9#A#B#C#D#E#F
    set "mod=!%mod:#=!!mod:#=%!"

set num_a=9999
set num_b=999999
for /l %%a in (1,1,250) do set num_a=!num_a!1
for /l %%a in (1,1,250) do set num_b=!num_b!1
set /a test = num_a + num_b
echo %test%

:bignum_plus
    set time_a=%time%
    call :length %num_a% len_a
    call :length %num_b% len_b
    set /a max = len_a
    if %len_b% gtr %len_a% (set /a max=len_b, len_b=len_a, len_a=max&set num_a=%num_b%&set num_b=%num_a%)

    set /a pool = 0
    for /l %%n in ( 1, 1, %max% ) do (
        if %%n leq %len_b% (
            set /a sum = !num_a:~-%%n,1! + !num_b:~-%%n,1! + pool
            if !sum! geq 10 (
                set /a buff[%%n] = sum - 10, pool = 1
            ) else (
                set /a buff[%%n] = sum, pool = 0
            )
        ) else (
            set /a sum = !num_a:~-%%n,1! + pool
            if !sum! geq 10 (
                set /a buff[%%n]=sum - 10, pool = 1
            ) else (
                set /a buff[%%n]=sum, pool = 0
            )
        )
    )
    
    if "%pool%" == "1" ( set /a max+=1 &set buff[!max!]=1)
    for /l %%a in (%max%, -1, 1) do set /p inp="!buff[%%a]!"<nul
    call :time_used %time_a% %time%
    goto :eof
    
:length %str% %vname%
    setlocal
    set "str=%mod%%~1%~1"
    set /a len=0x!str:~-512,2!
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
    echo,&echo time used: %dt:~0,2%.%dt:~2,2%s
    endlocal
    goto :eof

