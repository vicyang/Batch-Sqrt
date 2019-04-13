:: http://www.bathome.net/thread-52467-1-1.html
@echo off
setlocal enabledelayedexpansion
set num_a=456456521000210000000000000000874112115674511111111111111110019999999
set num_b=923451344221111111111111111000000000001
for /l %%a in (1,1,6) do set num_a=!num_a!!num_a!
for /l %%a in (1,1,6) do set num_b=!num_b!!num_b!

set t1=%time%
call :jia %num_a% %num_b% P
call :tt %t1% %time% t
echo %t%
echo %P%
exit

:jia
setlocal enabledelayedexpansion&set c1=%~1&set c2=%~2&set c=0&set t=
:j
    if %c%==0 (
        if "%c1%"=="" endlocal &set %~3=%c2%%t%&goto :eof
        if "%c2%"=="" endlocal &set %~3=%c1%%t%&goto :eof
    )
    ::此句为“加速版”增添的代码。
    set c1=000000000%c1%
    set c2=000000000%c2%
    set /a t=1!c1:~-9!-1000000000+1!c2:~-9!-1000000000+c,c=0&set c1=!c1:~9,-9!&set c2=!c2:~9,-9!&if "!c1!!c2!"=="" (set t=!t!%t%) else (if not "!t:~9!"=="" set c=1)&set t=00000000!t!&set t=!t:~-9!%t%&goto j
    endlocal&set %~3=%t%&goto :eof

:tt
setlocal&set be=%1:%2
for /f "delims=: tokens=1-6" %%a in ("%be:.=%")do set/at=(%%d-%%a)*360000+(1%%e-1%%b)*6000+1%%f-1%%c,t+=-8640000*("t>>31")
endlocal&set %3=%t%0ms&exit/b