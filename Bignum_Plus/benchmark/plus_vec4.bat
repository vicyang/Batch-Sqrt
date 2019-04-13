@echo off
setlocal enabledelayedexpansion
::constant
set /a BASE=1000000000, LEN=9, ZERO=0
set MASK=!BASE:~1!
for /l %%a in (1,1,12) do set ZERO=!ZERO!!ZERO!

call :func %1 %2 sum
echo %sum%
exit /b

:func
    setlocal enabledelayedexpansion
    set "sum=" & set "va=%1" & set "vb=%2"
    if "%va:~2000%"=="" (
        call :plus %va% %vb% 0 part1
    ) else (
        set vb=!ZERO!!vb!
        call :plus !va:~-2000! !vb:~-2000! 0 part1
        if not "!part1:~2000!"=="" (set c=1) else (set c=0)
        call :plus !va:~0,-2000! !vb:~0,-2000! !c! part2
    )
    if "%va:~2000%"=="" (endlocal &set %3=%part1%&goto :eof)
    set part1=!MASK!!part1!
    endlocal &set %3=%part2%%part1:~-2000%&goto :eof

:plus
    setlocal enabledelayedexpansion
    set "sum=" & set "va=%1" & set "vb=%2" & set c=%3
    :: fill zero if too short
    if "!va:~27!" == "" set va=!ZERO:~0,27!!va!
    if "!vb:~27!" == "" set vb=!ZERO:~0,27!!vb!
    :: 1 to 1000, because max strlen < 8192
    for /l %%a in (1,1,100) do (
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
    endlocal&set %4=%sum%&goto :eof

:tt
setlocal&set be=%1:%2
for /f "delims=: tokens=1-6" %%a in ("%be:.=%")do set/at=(%%d-%%a)*360000+(1%%e-1%%b)*6000+1%%f-1%%c,t+=-8640000*("t>>31")
endlocal&set %3=%t%0ms&exit/b
