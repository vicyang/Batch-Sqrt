
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


  * notes
    ```
    :: 比较 - 判断是否超出
    :cmp_begin
    if %mp_len% gtr %target_len% (set /a cmp=1,max=mid&goto :cmp_end)
    if %mp_len% lss %target_len% (set /a cmp=-1,min=mid&goto :cmp_end)
    :: 如果长度相同，直接按字符串对比
    if "%mp%" gtr "%target%" (set /a cmp=1,max=mid&goto :cmp_end)
    if "%mp%" lss "%target%" (set /a cmp=-1,min=mid&goto :cmp_end)
    if "%mp%" equ "%target%" (set /a cmp=0,quit=1,equ=1&goto :cmp_end)
    :cmp_end
    ```

    把 cmp 后面的if整合到cmp之中，效率变化不大，代码暂时保留

* Decimal_Method_OptC
  尝试直接预估结果，跳过二分搜索的部分。