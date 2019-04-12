rem http://www.bathome.net/thread-52467-1-1.html
@echo off
set num_a=456456521000210000000000000000874112115674511111111111111110019999999
set num_b=923451344221111111111111111000000000001
for /l %%a in (1,1,10) do set num_a=!num_a!!num_a!

call :jia %num_a% %num_b% P
echo %P%
exit

:jia
setlocal enabledelayedexpansion&set c1=%~1&set c2=%~2&set c=0&set t=
::c1、c2为加数，c为进位标识符，t储存结果。
:j
set c1=000000000%c1%&set c2=000000000%c2%&set/at=1!c1:~-9!-1000000000+1!c2:~-9!-1000000000+c,c=0&set c1=!c1:~9,-9!&set c2=!c2:~9,-9!&if "!c1!!c2!"=="" (set t=!t!%t%) else (if not "!t:~9!"=="" set c=1)&set t=00000000!t!&set t=!t:~-9!%t%&goto j
::前2句补0，然后set/a中脱去了c1、c2开头的0再相加，并同时把c重置为0。之后c1、c2分别截掉9位（此句的!!与~9配合之前的前补9个0实现了把未定义化为0），如果截掉后都没有了，则把t完完整整地补上去；若还有，则检测t是否超出9位，超出了就说明需要进位，然后把t补0、截9位再补回去，以还回之前set/a中脱去的0。
endlocal&set %~3=%t%&goto :eof