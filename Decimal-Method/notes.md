
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

* Decimal_Method_OptD
  尝试剔除整个二分搜索的代码

  BUG：
    SQRT 3
    1.73205080756887729353
    before tg 200, mp 21, base 2, mid 1
    before tg 17900, mp 1824, base 22, mid 8
    before tg 1607600, mp 14196, base 236, mid 6

    第二位数，目标值200，基数为2，因为200/2=100 取了1，导致结果为1
    实际远离目标要求。

  BUG: 
    SQRT 99999999
    before tg 9999999900, mp 7999999936, base 199999998, mid 4
    before tg 199999996400, mp 19999999881, base 1999999988, mid 1
    before tg 17999999651900, mp 1799999989461, base 19999999882, mid 9
    在第二行，错误地选择了数字1作为结果
    199999/19999 = 10
    实际
    199999996400/1999999988 = 99.9999988

    临时测试方案：如果est=10，并且target位数多于(base+1)，则est=9

    缺点：
      tg 3899, mp 5024, base 62, mid 8, est 9
      3899/62 ~= 62，但是3899比62超出两位数，结果被判定为9而不是6

    解决方案：
    ```perl
            if %base_len% gtr 5 (
                set /a est=!target:~0,6!/!base:~0,5!
            ) else (
                set /a est=target/base
            )
    ```
    else部分的计算改为
    `set /a est=target/%base%0`
    （原本应该设定一个 tbase=base*10+n，所以这里直接补0作为基数不会有问题）

    优化某些简单数字的长度判断
    `if !base! geq 10 (set /a base_len=2) else (set /a base_len=1)`
    改为
    `set /a base=mid*2, base_len=1+base/10`

    `if !db_mid! geq 10 (set /a dbmidlen=2) else (set /a dbmidlen=1)`
    改为
    `set /a db_mid=mid*2, dbmidlen=1+db_mid/10`

* Decimal_Method_Float
  基于 Decimal_Method_OptD 没有二分，直接估值
  
  需要留意的问题
  for /l %%a in (0,1,10) do (
    set /a mp=%base%%%a*%%a
    if !mp! gtr !target! (set /a est=%%a-1 &goto :out_est_for)
  )
  直接拼接可能导致八进制错误，%base%可能为0

  解决方法：
  set /a mp=^(base*10+%%a^)*%%a

  set /a est=!target:~0,6!/!base:~0,5! 不会有这样的问题
  因为只有当结果中出现非0的数字以后 base 才会逐位地叠加

  ```shell
        :: 更新基数 - base
        rem base=base*10+mid*2
        if "%base%" == "0" (
            set /a base=mid*2, base_len=1+base/10
        ) else (
            set /a db_mid=mid*2, dbmidlen=1+db_mid/10
            call :bignum_plus !base!0 !db_mid! !base_len!+1 !dbmidlen! base base_len
        )
  ```
  