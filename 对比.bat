@echo off
setlocal enabledelayedexpansion
:init
  set mod=
  set /a maxlen=1000
  for /l %%a in (1,1,%maxlen%) do set mod=!mod!#

call :cmp 123456799000000000000000 123456799000000000000000 res
echo %res%
pause
exit /b

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
  echo %len_a%
  echo %len_b%
  if %len_a% gtr %len_b% (set %3=1&goto :eof)
  if %len_a% lss %len_b% (set %3=-1&goto :eof)
  set str1=%1
  set str2=%2
  if %len_a% equ %len_b% (
    echo abc
    for /l %%n in (0, 1, %len_a%) do (
      if "!str1:~%%n,1!" gtr "!str2:~%%n,1!" (set %3=1&goto :eof)
      if "!str1:~%%n,1!" lss "!str2:~%%n,1!" (set %3=-1&goto :eof)
    )
    set %3=0
  )
  goto :eof
