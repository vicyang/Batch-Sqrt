@echo off
setlocal enabledelayedexpansion
::test
set num_a=456456521000210000000000000000874112115674511111111111111110019999999
set num_b=923451344221111111111111111000000000001
for /l %%a in (1,1,6) do set num_a=!num_a!!num_a!
for /l %%b in (1,1,6) do set num_b=!num_b!!num_b!

call :strlen %num_a% la
call :strlen %num_b% lb

echo %la% %lb%

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