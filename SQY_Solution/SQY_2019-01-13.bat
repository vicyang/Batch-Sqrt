@echo off & SetLocal EnableDelayedExpansion & color f0
for /l %%a in (1,1,101) do (
    call :func %%a
)

exit

:func
(
	::变量a的值是被开方数，不得超过10000（一万）！
	set a=%1
    call :check_first !a! 80
	set "b=!a!54321" & set "b=!b:~5,1!" & for /l %%a in (!b! -1 1) do set c=-!c!
	title 计算!a!的算数平方根 
	set "a0=0" & for /l %%a in (6 -1 0) do (
		set /a "b=1<<%%a" & set /a "b+=!a0!" & set /a "b*=!b!"
		if !a! geq !b! set /a "a0+=1<<%%a"
	)
	set /a "b0=!a0!*!a0!"
	if "!b0!"=="!a!" echo !a0! & echo.  & exit /b
	set /p=!a0!.<nul
	set "a2=0" & for /l %%a in (9 -1 0) do (
		set /a "a2+=1<<%%a"
		set "b=!a2!" & set /a "b*=!b!"
		set "c=!a2!" & set /a "c*=!a0!<<1" & set /a "c+=!b!/1000" & set /a "c/=1000" & set /a "c+=!b0!"
		if !c! geq !a! set /a "a2-=1<<%%a"
	)
	set "a=000!a2!" & set /p=!a:~-3!<nul
	set /a "a=!a0!*!a2!000<<1" & set /a "a+=!a2!*!a2!
	set /a "b0+=!a!/1000000" & set /a "b0%%=1000"
	set /a "b2=!a!%%1000000" & set /a "b1=!b2!/1000" & set /a "b2%%=1000"
	for /l %%a in (2 2 50) do (
		set "a=0" & for /l %%b in (9 -1 0) do (
			set /a "a+=1<<%%b" & if !a! lss 1000 (
				set /a "b=!a!*!a!" & set /a "b/=1000"
				set /a "c=%%a+1" & set "b!c!=0" & for /l %%c in (%%a -2 0) do (
					set /a "c!c!=!a%%c!*!a!<<1"
					for %%d in (!c!) do set /a "c%%d+=!b!+!b%%d!" & set /a "b=!c%%d!/1000"
					set /a "c-=1"
				)
				for %%c in (!c!) do (
					set /a "c%%c=!b!+!b%%c!" & set /a "c%%c%%=1000"
					set "b=000!c%%c!" & set "b=!b:~-3!"
					if not "!b:~0,1!"=="9" set /a "a-=1<<%%b"
				)
			) else set /a "a-=1<<%%b"
		)
		set /a "b=!a!*!a!" & set /a "b/=1000"
		set /a "c=%%a+2" & for /l %%b in (%%a -2 0) do (
			set /a "c-=1"
			set /a "b!c!+=!a%%b!*!a!<<1" & set /a "b!c!+=!b!"
			for %%d in (!c!) do set /a "b=!b%%d!/1000"
			set /a "b!c!%%=1000"
		)
		set /a "c=%%a+2"
		set /a "b!c!=!a!*!a!" & set /a "b!c!%%=1000"
		set "a!c!=!a!"
		set "b=000!a!" & set /p=!b:~-3!<nul
	)
	echo, &echo, & goto :eof
)

:check_first
    perl -Mbignum=p,-%2 -le "print sqrt(%1)" 2>nul
    goto :eof
