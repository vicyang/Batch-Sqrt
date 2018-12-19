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
    call :bignum_mp %a%%b% %a%%b% res
    call :cmp %res% %num%00 cmp
    rem exit
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

:bignum_mp
    setlocal
    set num_a=%~1
    set num_b=%~2
    call :length %~1 len_a
    call :length %~2 len_b
    for /l %%b in ( 1, 1, %len_b% ) do ( set ele_b=!ele_b! !num_b:~-%%b,1! )
    for /l %%a in ( 1, 1, %len_a% ) do ( set ele_a=!ele_a! !num_a:~-%%a,1! )
    rem for /l %%a in (0, 1, %attemplen%) do set buff[%%a]=0
    set /a id = 0, sid = 0, maxid = 0
    for %%b in ( %ele_b% ) do (
        set /a sid = id, id += 1
        for %%a in ( %ele_a% ) do (
            set /a mp = %%a * %%b
            if "%mp%" geq "10" (
                set /a next = sid + 1
                set /a foo = mp/10, bar = mp %% 10
                set /a buff[!sid!] += bar, ^
                        buff[!next!] += foo, ^
                        sid += 1, maxid = sid
            ) else (
                set /a buff[!sid!] += mp, sid += 1, maxid = sid
            )
        )
    )
    :merge
        set /a id = 0
        for /l %%c in ( 0, 1, %maxid% ) do (
            set /a next = %%c+1
            set /a buff[!next!] += buff[%%c]/10, buff[%%c] = buff[%%c] %% 10
        )

    if "!buff[%maxid%]!" == "0" set /a maxid-=1
    set result=
    for /l %%a in (%maxid%, -1, 0) do set result=!result!!buff[%%a]!
    endlocal &set %3=%result%
    goto :eof

rem 
:length %str% %vname%
    setlocal
    set test=%~1_%mod%
    set test=!test:~0,%maxlen%!
    set test=%test:*_=%
    set /a len=maxlen-(%test:#=1+%1)
    endlocal &set %2=%len%
    goto :eof

:cmp %str1% %str2% %vname%
    setlocal
    call :length %1 len_a
    call :length %2 len_b
    if "%len_a%" gtr "%len_b%" (endlocal &set %3=1&goto :eof)
    if "%len_a%" lss "%len_b%" (endlocal &set %3=-1&goto :eof)
    set str1=%1
    set str2=%2
    if %len_a% equ %len_b% (
        for /l %%n in (0, 1, %len_a%) do (
            if "!str1:~%%n,1!" gtr "!str2:~%%n,1!" (endlocal &set %3=1&goto :eof)
            if "!str1:~%%n,1!" lss "!str2:~%%n,1!" (endlocal &set %3=-1&goto :eof)
        )
        endlocal &set %3=0
    )
    goto :eof
