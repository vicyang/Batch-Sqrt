@echo off&setlocal enabledelayedexpansion
set a=456456521000210000000000000000874112115674511111111111111110019999999
set b=923451344221111111111111111000000000001
for /l %%a in (1,1,6) do set a=!a!!a!
for /l %%b in (1,1,6) do set b=!b!!b!

set t1=%time%
call :jia %a% %b% P
:next
call :tt %t1% %time% t
echo %t%
echo %P%&exit

:jia
setlocal enabledelayedexpansion&set c1=%1&set c2=%2&set c=0&set t=&set s=
::c1、c2为加数，c为进位标识符，t储存结果。
for /l %%i in () do set c1=000000000!c1!&set c2=000000000!c2!&set/ac=(t=1!c1:~-9!-1000000000+1!c2:~-9!-1000000000)/1000000000&set c1=!c1:~9,-9!&set c2=!c2:~9,-9!&if "!c1!!c2!"=="" (set s=!t!!s!&call :j %~3) else set t=00000000!t!&set s=!t:~-9!!s!
::前2句补0，然后set/a中脱去了c1、c2开头的0再相加，若t达到10位则置c为1否则置0。之后c1、c2分别截掉9位（此句的!!与~9配合之前的前补9个0实现了把未定义化为0），如果截掉后都没有了，则把t完完整整地补上去，并准备结束；若还有，则把t补0、截9位再补回去，以还回之前set/a中脱去的0。
:j
endlocal&set %1=%s%&goto next

:tt
setlocal&set be=%1:%2
for /f "delims=: tokens=1-6" %%a in ("%be:.=%")do set/at=(%%d-%%a)*360000+(1%%e-1%%b)*6000+1%%f-1%%c,t+=-8640000*("t>>31")
endlocal&set %3=%t%0ms&exit/b