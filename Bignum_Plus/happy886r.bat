@echo off&setlocal enabledelayedexpansion
title By Happy
REM 大数长度
set "MAX=5000" ^位
REM 分割大小
set "K=8"      ^位
set /a CYC=MAX/K
:MAIN
cls

set num_a=456456521000210000000000000000874112115674511111111111111110019999999
set num_b=923451344221111111111111111000000000001
for /l %%a in (1,1,6) do set num_a=!num_a!!num_a!
for /l %%a in (1,1,6) do set num_b=!num_b!!num_b!

set A=%num_a%
set B=%num_b%

REM 优化字符
setlocal
CALL :POINT !A! A N1
CALL :POINT !B! B N2

set /a B1=N1*K
set /a B2=N2*K
echo ======================================
echo 被加数信息:  预估!B1!位
echo   加数信息:  预估!B2!位
echo ======================================
echo 计算结果

REM 加法核心
if !N1! gtr !N2! (set RM=!N1! &set dx=B) else (set RM=!N2! &set dx=A)
for /l %%i in (1 1 !RM!) do (
	if not defined !dx![%%i] (set "!dx![%%i]=00000000")
	set /a sum=1!A[%%i]!+1!B[%%i]!+sum
	set S=!sum:~-%K%!!S!
	set /a sum=!sum:~0,1!-2
)

REM 显示
:DISP
for /l %%i in (1 1 8) do (if "!S:~0,1!"=="0" (set S=!S:~1!))
if "!S!"=="" (set S=0)
echo,!S!
endlocal
goto :eof

REM 分割数位
:POINT
set num=%1
for /l %%i in (1 1 !CYC!) do (
	set %2[%%i]=!num:~-%K%!
	set num=!num:~0,-%K%!
	if "!num!"=="" (
		set /a CU=!%2[%%i]!+100000000
		set %2[%%i]=!CU:~-%K%!
		set /a %3=%%i
		goto :eof
	)
)