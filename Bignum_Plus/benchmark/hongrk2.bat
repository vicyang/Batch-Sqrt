:: http://www.bathome.net/thread-52467-1-1.html
@echo off
setlocal enabledelayedexpansion
call :jia %1 %2 P
echo %P%
exit /b

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
