@echo off&setlocal enabledelayedexpansion
call :jia %1 %2 P
:next
echo %P%
rem call check.pl %a% %b%
exit

:jia
setlocal enabledelayedexpansion&set c1=%1&set c2=%2&set c=0&set t=&set s=
::c1��c2Ϊ������cΪ��λ��ʶ����t��������
for /l %%i in () do set c1=000000000!c1!&set c2=000000000!c2!&set/ac=(t=1!c1:~-9!-1000000000+1!c2:~-9!-1000000000)/1000000000&set c1=!c1:~9,-9!&set c2=!c2:~9,-9!&if "!c1!!c2!"=="" (set s=!t!!s!&call :j %~3) else set t=00000000!t!&set s=!t:~-9!!s!
::ǰ2�䲹0��Ȼ��set/a����ȥ��c1��c2��ͷ��0����ӣ���t�ﵽ10λ����cΪ1������0��֮��c1��c2�ֱ�ص�9λ���˾��!!��~9���֮ǰ��ǰ��9��0ʵ���˰�δ���廯Ϊ0��������ص���û���ˣ����t���������ز���ȥ����׼�������������У����t��0����9λ�ٲ���ȥ���Ի���֮ǰset/a����ȥ��0��
:j
endlocal&set %1=%s%&goto next

:tt
setlocal&set be=%1:%2
for /f "delims=: tokens=1-6" %%a in ("%be:.=%")do set/at=(%%d-%%a)*360000+(1%%e-1%%b)*6000+1%%f-1%%c,t+=-8640000*("t>>31")
endlocal&set %3=%t%0ms&exit/b