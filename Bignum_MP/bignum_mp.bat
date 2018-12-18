@echo off
setlocal enabledelayedexpansion

:init
  rem static template for calculating strlen
  set "mod="
  set /a maxlen = 1000
  for /l %%a in (1,1,%maxlen%) do set mod=!mod!#


set num_a=123456
set num_b=9999
set num_a=1234569999999999999999999999999999999999999999999999999999999999
set num_b=9999999999999999999999999999999999999999999999999999999999999999999999999999999

:bignum_mp
    echo %time%
    call :length %num_a% len_a
    call :length %num_b% len_b

    for /l %%b in ( 1, 1, %len_b% ) do ( set ele_b=!ele_b! !num_b:~-%%b,1! )
    for /l %%a in ( 1, 1, %len_a% ) do ( set ele_a=!ele_a! !num_a:~-%%a,1! )
    rem for /l %%a in (0, 1, %attemplen%) do set buff[%%a]=0
    set /a id = 0, sid = 0, maxid = 0
    for %%b in ( %ele_b% ) do (
        set /a sid = id, id+=1
        for %%a in ( %ele_a% ) do (
            set /a next = sid + 1
            set /a mp = %%a * %%b, foo = mp/10, bar = mp %% 10
            set /a buff[!sid!] += bar, buff[!next!] += foo
            set /a sid += 1, maxid = sid
        )
    )
    echo %time%

    :merge
        set /a id = 0
        for /l %%c in ( 0, 1, %maxid% ) do (
            set /a next = %%c+1
            set /a buff[!next!] += buff[%%c]/10
            set /a buff[%%c] = buff[%%c] %% 10
        )

    for /l %%a in (%maxid%, -1, 0) do set /p inp="!buff[%%a]!"<nul
    goto :eof
    
:length %str% %vname%
    setlocal
    set test=%1_%mod%
    set test=!test:~0,%maxlen%!
    set test=%test:*_=%
    set /a len=maxlen-(%test:#=1+%1)
    endlocal &set %2=%len%
    goto :eof


