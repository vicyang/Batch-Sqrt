@echo off
setlocal enabledelayedexpansion
::constant
set /a BASE=1000000000, LEN=9
set MASK=!BASE:~1!

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
    set /a carry=0, pos=0
    :: 1 to 1000, because max strlen < 8192
    :lp
        ::set /a pos+=LEN
        set /a a=1!va:~-9, %LEN%!-BASE, b=1!vb:~-9,%LEN%!-BASE
        set /a t=a+b+carry, carry=t/BASE, head=t
        set t=!MASK!!t!
        set va=!MASK!!va:~0,-9!
        set vb=!MASK!!vb:~0,-9!
        if "!va:0=!!vb:0=!" == "" (goto :next)
        set sum=!t:~-%LEN%!!sum!
    goto :lp
    :next
    endlocal&set %3=%head%%sum%&goto :eof


:tt
setlocal&set be=%1:%2
for /f "delims=: tokens=1-6" %%a in ("%be:.=%")do set/at=(%%d-%%a)*360000+(1%%e-1%%b)*6000+1%%f-1%%c,t+=-8640000*("t>>31")
endlocal&set %3=%t%0ms&exit/b