@echo off
setlocal enabledelayedexpansion
:init
  set mod=
  set /a maxlen=1000
  for /l %%a in (1,1,%maxlen%) do set mod=!mod!#

set /a num=2
set /a a=1, b=0, count=0
set /p inp="%a%"<nul
:lp
  call :cen %a%%b% %a%%b% res
  call :cmp %res% %num%00 cmp
  if "%cmp%" == "1" (
    set /a b-=1,count+=1
    set /p inp="!b!"<nul
    set a=%a%!b!
    set num=%num%00
    set b=0
  ) else (
    set /a b+=1
  )
if %count% lss 50 goto :lp
rem echo %num% %a% %res%
pause
exit

:cen 乘法函数（封装）by @随风 @bbs.bathome.net
  ::计算任意位数的正整数乘法
  setlocal enabledelayedexpansion
  if "%~1"=="0" Endlocal&set %~3=0&goto :EOF
  if "%~2"=="0" Endlocal&set %~3=0&goto :EOF
  set f=&set jia=&set ji=&set /a n1=0,n2=0
  set vard1=&set "vard2="&set var1=%~1&set "var2=%~2"
  for /l %%a in (0 1 9) do (
  set var1=!var1:%%a= %%a !&set var2=!var2:%%a= %%a !)
  for %%a in (!var1!)do (set /a n1+=1&set vard1=%%a !vard1!)
  for %%a in (!var2!)do (set /a n2+=1&set vard2=%%a !vard2!)
  if !n1! gtr !n2! (set vard1=%vard2%&set vard2=%vard1%)
  for %%a in (!vard1!) do (set "t="&set /a j=0
  for %%b in (!vard2!) do (if "!jia!"=="" set /a jia=0
  set /a a=%%a*%%b+j+!jia:~-1!&set "t=!a:~-1!!t!"
  set a=0!a!&set "j=!a:~-2,1!"&set jia=!jia:~0,-1!)
  set "ji=!t:~-1!!ji!"
  if "!j:~0,1!"=="0" (set ss=) else set "ss=!j:~0,1!"
  set jia=!ss!!t:~0,-1!)
  if not "!j:~0,1!"=="0" set "t=!j:~0,1!!t!"
  set "ji=!t!!ji:~1!"
  Endlocal&set %~3=%ji%&goto :EOF

rem 粗略判断字符串长度
:length %str% %vname%
  setlocal
  set test=%1_%mod%
  set test=!test:~0,%maxlen%!
  set test=%test:*_=%
  set /a len=maxlen-(%test:#=1+%1)
  endlocal &set %2=%len%
  goto :eof

:cmp %str1% %str2% %vname%
  call :length %1 len_a
  call :length %2 len_b
  if "%len_a%" gtr "%len_b%" (set %3=1&goto :eof)
  if "%len_a%" lss "%len_b%" (set %3=-1&goto :eof)
  set str1=%1
  set str2=%2
  if %len_a% equ %len_b% (
    for /l %%n in (0, 1, %len_a%) do (
      if "!str1:~%%n,1!" gtr "!str2:~%%n,1!" (set %3=1&goto :eof)
      if "!str1:~%%n,1!" lss "!str2:~%%n,1!" (set %3=-1&goto :eof)
    )
    set %3=0
  )
  goto :eof
