```cmd
:start
    echo.&echo 请输入被开方数（仅限整数）,然后按回车键：
    echo （被开方数最高为2147483646，超出范围，会计算出错）
    set number=
    set /p "number="
    goto get_number

:get_number
    cls
    if "%number%"=="" goto start
    set /a temp=%number%+0
    if not "%temp%"=="%number%" goto error_a
    if not %number% geq 0 goto error_b
    if %number% geq 2147483647 goto error_c
    goto set_precision

:set_precision
    cls
    echo.&echo 请输入精确位数,然后按回车键：
    echo （指精确到小数点后第几位）
    echo （该程序不会对最后一位进行四舍五入）
    echo （精确位数最高为238609294，超出范围，会计算出错）
    echo （对于结果为整数的，程序会舍去小数部分）
    set bit=
    set /p "bit="
    goto chk_precision

:chk_precision
    cls
    if "%bit%"=="" goto then
    set /a temp=%bit%+0
    if not "%bit%"=="%temp%" goto error_d
    if not %bit% geq 0 goto error_d
    if %bit% geq 238609295 goto error_e
    set start=yes
    goto main
```

```cmd
:save_and_exit
    if "%bit%"=="0" (
        set info=（保留整数）
    ) else (
        set info=（精确到小数点后第%bit%位）
    )
    cd /d "%UserProfile%\desktop"
    set fname="%number%的平方根的结果%info%.txt"
    rem 若存在同名文件，获取权限
    if exist %fname% takeown %fname%
    
    >%fname% (
        echo %number%的平方根的结果：
        echo %info%：
        echo （未对其结果进行四舍五入）：
        echo %nun%
    )
    goto exit
```