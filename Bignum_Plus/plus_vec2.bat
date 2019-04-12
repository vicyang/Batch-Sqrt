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

call :plus %num_a% %num_b% sum
echo %sum%
exit /b

:plus
    setlocal
    set "sum=" & set "va=%1" & set "vb=%2"
    set /a carry=0
    :: 1 to 1000, because max strlen < 8192
    for /l %%a in (1,1,1000) do (
        set /a a=1!va:~-%LEN%, %LEN%!-BASE, b=1!vb:~-%LEN%,%LEN%!-BASE, t=a+b+carry, head=t
        if !t! geq !BASE! (set /a carry=1) else ( set /a carry=0&set t=!MASK!!t!)
        set va=!MASK!!va:~0,-%LEN%!
        set vb=!MASK!!vb:~0,-%LEN%!
        if "!va:0=!!vb:0=!" == "" (goto :next)
        set sum=!t:~-%LEN%!!sum!
    )
    :next
    endlocal&set %3=%head%%sum%&goto :eof
