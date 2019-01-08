@echo off
(
    SetLocal EnableDelayedExpansion
    color f0
    rem 设置被开方数（number）（不超过20）（别输入正好能开出来的）
    set number=5
    rem 输入被开方数的整数部分（num）
    set num=1
    echo ------------------
    echo 计算!number!的平方根的值
    echo ------------------
    set nun=!num!
    set /a "bv=!number!-(!num!*!num!)+!num!"
    set q[4]=0000
    set q[2]=00
    set q[1]=0
    set /p=!num!.<nul
    set zz=-5
    for /l %%a in (0 1 10000) do (
        set /a zz+=6
        set temp=0
        for %%b in (512 256 128 64 32 16 8 4 2 1) do (
            set /a temp+=%%b
            if not !temp! geq 1000 (
                set /a c=%%a/2+1
                set d=!num!
                for /l %%c in (1 1 !c!) do (
                    set o=000000!d:~-6!
                    set o=1!o:~-6!
                    set /a o-=1000000
                    set /a "b[%%c]=!o!*!temp!<<1"
                    set d=!d:~0,-6!
                    if not defined d set d=0
                )
                set /a y=!temp!*!temp!
                set /a b[1]+=!y!/1000
                for /l %%c in (1 1 !c!) do (
                    set /a d=%%c+1
                    set /a b[!d!]+=!b[%%c]!/1000000
                )
                set h=!a!
                set a=
                for /l %%c in (1 1 !c!) do (
                    if not !c!==%%c (
                        set /a b[%%c]=!b[%%c]!%%1000000
                        set b[%%c]=000000!b[%%c]!
                        set b[%%c]=!b[%%c]:~-6!
                    ) else (
                        if "!b[%%c]!"=="0" set b[%%c]=
                    )
                    set a=!b[%%c]!!a!
                )
                set z=!b!
                set i=!a:~0,-3!
                if not defined i set i=0
                set x=!nun!
                set /a v=!zz!/9+1
                for /l %%v in (1 1 !v!) do (
                    set u=!i:~-9!
                    set w=!x:~-9!
                    for %%f in (4 2 1) do (
                        if "!u:~0,%%f!"=="!q[%%f]!" set u=!u:~%%f!
                        if not defined u set u=0
                    )
                    for %%f in (4 2 1) do (
                        if "!w:~0,%%f!"=="!q[%%f]!" set w=!w:~%%f!
                        if not defined w set w=0
                    )
                    set /a k[%%v]=!u!+!w!
                    set i=!i:~0,-9!
                    set x=!x:~0,-9!
                    if not defined i set i=0
                    if not defined x set x=0
                )
                for /l %%v in (1 1 !v!) do (
                    set /a i=%%v+1
                    set /a k[!i!]+=!k[%%v]!/1000000000
                )
                set b=
                for /l %%v in (1 1 !v!) do (
                    if not "%%v"=="!v!" (
                        set /a k[%%v]=!k[%%v]!%%1000000000
                        set k[%%v]=0000000000!k[%%v]!
                        set k[%%v]=!k[%%v]:~-9!
                    ) else (
                        if "!k[%%v]!"=="0" set k[%%v]=
                    )
                    set b=!k[%%v]!!b!
                )
                set ew=!b:~0,1!
                if !ew! geq !bv! (
                    set /a temp-=%%b
                    set b=!z!
                    set a=!h!
                )
            ) else (
                set /a temp-=%%b
            )
        )
        set /a "g=(!temp!*!temp!)%%1000"
        if !g! lss 100 (
            if !g! lss 10 (
                set nun=!b!!a:~-3!00!g!
            ) else (
                set nun=!b!!a:~-3!0!g!
            )
        ) else (
            set nun=!b!!a:~-3!!g!
        )
        if !temp! lss 100 (
            if !temp! lss 10 (
                set /p=00!temp!<nul
                set num=!num!00!temp!
            ) else (
                set /p=0!temp!<nul
                set num=!num!0!temp!
            )
        ) else (
            set /p=!temp!<nul
            set num=!num!!temp!
        )
        set a=000
        set b=!nun!
    )
    pause
    exit /b
)