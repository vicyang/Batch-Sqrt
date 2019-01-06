
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

* Decimal_Method_OptB
  尝试在 Decimal_Method_Opt 的基础上
  对二分搜索循环进行优化，当得出当前的积大于或者小于目标值的时候，
  做减法，如果相减的值小于“基数”，则可以提前判定mid的值而退出循环

  中间所增加的操作也许反而会增加耗时
