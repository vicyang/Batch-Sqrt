@echo off
setlocal enabledelayedexpansion
::constant
set /a BASE=1000000000, LEN=9
set MASK=!BASE:~1!
set DBMASK=!MASK!!MASK!

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
    set /a c1=0, c2=0, c3=0
    :: 1 to 1000, because max strlen < 8192
    for /l %%a in (1,1,300) do (
        set /a a=1!va:~-9,9!-BASE,  b=1!vb:~-9,9!-BASE, ^
               i=1!va:~-18,9!-BASE, j=1!vb:~-18,9!-BASE, ^
               m=1!va:~-27,9!-BASE, n=1!vb:~-27,9!-BASE
        set /a t1=a+b+c, c=t1/BASE, h1=t1, ^
               t2=i+j+c, c=t2/BASE, h2=t2, ^
               t3=m+n+c, c=t3/BASE, h3=t3
        set t1=!MASK!!t1!
        set t2=!MASK!!t2!
        set t3=!MASK!!t3!
        set va=!MASK!!va:~0,-27!
        set vb=!MASK!!vb:~0,-27!
        if "!va:0=!!vb:0=!" == "" (goto :next)
        set sum=!t3:~-%LEN%!!t2:~-%LEN%!!t1:~-%LEN%!!sum!
    )
    :next
    endlocal&set %3=%h2%%h1%%sum%&goto :eof


:tt
setlocal&set be=%1:%2
for /f "delims=: tokens=1-6" %%a in ("%be:.=%")do set/at=(%%d-%%a)*360000+(1%%e-1%%b)*6000+1%%f-1%%c,t+=-8640000*("t>>31")
endlocal&set %3=%t%0ms&exit/b