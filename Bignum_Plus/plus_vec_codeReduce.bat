@echo off
setlocal enabledelayedexpansion
::constant
set /a BASE=1000000000, L=9
set MK=!BASE:~1!

::test
set num_a=456456521000210000000000000000874112115674511111111111111110019999999
set num_b=923451344221111111111111111000000000001
for /l %%a in (1,1,6) do set num_a=!num_a!!num_a!
for /l %%b in (1,1,6) do set num_b=!num_b!!num_b!

call :plus %num_a% %num_b% sum
echo %sum%
exit /b

:plus
    setlocal enabledelayedexpansion
    set "sum=" &set "va=%1" &set "vb=%2" &set carry=0
    for /l %%a in (1,1,1000) do (
        set /a a=1!va:~-%L%, %L%!-BASE, b=1!vb:~-%L%,%L%!-BASE, t=a+b+carry, carry=t/BASE, head=t
        set t=!MK!!t!& set va=!MK!!va:~0,-%L%!& set vb=!MK!!vb:~0,-%L%!
        if "!va:0=!!vb:0=!" == "" (goto :next)
        set sum=!t:~-%L%!!sum!
    )
    :next
    endlocal&set %3=%head%%sum%&goto :eof
