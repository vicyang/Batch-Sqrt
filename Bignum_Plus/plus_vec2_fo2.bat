@echo off
setlocal enabledelayedexpansion
::constant
set /a BASE=1000000000, LEN=9, MAX=8000, ZERO=0
set MASK=!BASE:~1!
for /l %%a in (1,1,12) do set ZERO=!ZERO!!ZERO!
set ZERO=!ZERO:~0,4000!!ZERO:~0,4000!

::test
set num_a=456456521000210000000000000000874112115674511111111111111110019999999
set num_b=923451344221111111111111111000000000001
for /l %%a in (1,1,6) do set num_a=!num_a!!num_a!
for /l %%b in (1,1,6) do set num_b=!num_b!!num_b!

set t1=%time%
call :plus %num_a% %num_b% sum
call :tt %t1% %time% t
echo %t%
echo %sum%
exit /b

:plus
    setlocal enabledelayedexpansion
    set "sum=" & set "va=%1" & set "vb=%2"
    call :strlen %va% la
    call :strlen %vb% lb
    set /a dt=la-lb
    if %la% gtr %lb% (
        set vb=!ZERO:~0,%dt%!!vb!
        set /a lmt=la
    ) else (
        set va=!ZERO:~0,%dt:-=%!!va!
        set /a lmt=lb
    )
    set va=!MASK!!MASK!!va!
    set vb=!MASK!!MASK!!vb!

    set /a c=0
    :: max strlen < 8192
    for /l %%n in (18,18,9000) do (
        set ta=!va:~-%%n, 18!
        set tb=!vb:~-%%n, 18!
        set /a a=1!ta:~9, 9!-BASE, b=1!tb:~9, 9!-BASE, ^
               i=1!ta:~0, 9!-BASE, j=1!tb:~0, 9!-BASE
        set /a t1=a+b+c, c=t1/BASE, h1=t1, t1+=^(1-c^)*BASE, ^
               t2=i+j+c, c=t2/BASE, h2=t2, t2+=^(1-c^)*BASE
        if %%n geq %lmt% (goto :next)
        set sum=!t2:~-%LEN%!!t1:~-%LEN%!!sum!
    )
    
    :next
    if %h2% gtr 0 (
        set sum=%h2%!t1:~-%LEN%!%sum%
    ) else if %h1% gtr 0 (
        set sum=%h1%%sum%
    )
    endlocal&set %3=%sum%&goto :eof

:strlen
::strlen function from bathome
setlocal
set "$=%1#"
set len=&for %%a in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1)do if !$:~%%a^,1!. NEQ . set/a len+=%%a&set $=!$:~%%a!
endlocal&set %2=%len%&goto :eof

:tt
setlocal&set be=%1:%2
for /f "delims=: tokens=1-6" %%a in ("%be:.=%")do set/at=(%%d-%%a)*360000+(1%%e-1%%b)*6000+1%%f-1%%c,t+=-8640000*("t>>31")
endlocal&set %3=%t%0ms&exit/b