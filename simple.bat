@echo off
:action
set /p input="(1-99):"
if "%input%"=="" goto :action
set /a a=0,n=0
:a
set /a a+=1,a1=0
    :a1
     set /a a1+=1,test=(n*10+a1)*(n*10+a1)
     if %test% equ %input% (echo %a1% &pause &goto :end)
    if %test% lss %input% (goto :a1)
set /a n=n*10+a1-1, input*=100
if %a% lss 6 goto :a
echo %n:~0,1%.%n:~1%
pause>nul
:end
echo,&set input=
goto :action