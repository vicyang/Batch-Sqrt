@echo off
setlocal enabledelayedexpansion

set t1=%time%
::constant
set /a BASE=1000000000, LEN=9, ZERO=0
set MASK=!BASE:~1!
for /l %%a in (1,1,12) do set ZERO=!ZERO!!ZERO!

::test
set num_a=456456521000210000000000000000874112115674511111111111111110019999999
set num_b=923451344221111111111111111000000000001
rem set num_b=9
for /l %%a in (1,1,6) do set num_a=!num_a!!num_a!
for /l %%b in (1,1,6) do set num_b=!num_b!!num_b!

call :plus %num_a% %num_b% sum
call :tt %t1% %time% t
echo %t%
echo %sum%

call check.pl %num_a% %num_b%
exit /b

:plus
    setlocal enabledelayedexpansion
    set "sum=" & set "va=%1" & set "vb=%2"
    :: fill zero if too short
    if "!va:~27!" == "" set va=!ZERO:~0,27!!va!
    if "!vb:~27!" == "" set vb=!ZERO:~0,27!!vb!
    set /a c=0
    :: 1 to 1000, because max strlen < 8192
    for /l %%a in (1,1,300) do (
        set /a a=1!va:~-9,9!-BASE,  b=1!vb:~-9,9!-BASE, ^
               i=1!va:~-18,9!-BASE, j=1!vb:~-18,9!-BASE, ^
               m=1!va:~-27,9!-BASE, n=1!vb:~-27,9!-BASE
        set /a t1=a+b+c, c=t1/BASE, h1=t1, t1+=^(1-c^)*BASE, ^
               t2=i+j+c, c=t2/BASE, h2=t2, t2+=^(1-c^)*BASE, ^
               t3=m+n+c, c=t3/BASE, h3=t3, t3+=^(1-c^)*BASE
        set va=!MASK!!va:~0,-27!
        set vb=!MASK!!vb:~0,-27!
        if "!va:0=!!vb:0=!" == "" (goto :next)
        set sum=!t3:~-%LEN%!!t2:~-%LEN%!!t1:~-%LEN%!!sum!
    )
    :next
    if %h3% gtr 0 (
        set sum=%h3%!t2:~-%LEN%!!t1:~-%LEN%!%sum%
    ) else if %h2% gtr 0 (
        set sum=%h2%!t1:~-%LEN%!%sum%
    ) else if %h1% gtr 0 (
        set sum=%h1%%sum%
    )
    endlocal&set %3=%sum%&goto :eof

:tt
setlocal&set be=%1:%2
for /f "delims=: tokens=1-6" %%a in ("%be:.=%")do set/at=(%%d-%%a)*360000+(1%%e-1%%b)*6000+1%%f-1%%c,t+=-8640000*("t>>31")
endlocal&set %3=%t%0ms&exit/b
