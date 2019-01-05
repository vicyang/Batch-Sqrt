
```bat
@echo off
setlocal enabledelayedexpansion

set /a base=446, target=27100
:guess
for /l %%a in (1,1,9) do (
    set /a t = %%a * !base:~0,1!, test = !target:~0,2!
    echo !t! !target:~0,2! %%a
    if !t! gtr !test! (
        set /a max = %%a+1
        goto :out_of_guess
    )
)
:out_of_guess

rem 这里不能使用  if !t! gtr !target:~0,2! ，会被当作字符串判断大小而非数字
```

