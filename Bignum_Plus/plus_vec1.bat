@echo off
setlocal enabledelayedexpansion
set num_a=456456521000210000000000000000874112115674511111111111111110019999999
set num_b=923451344221111111111111111000000000001
set /a BASE=100000000, MAX=BASE*10
for /l %%a in (1,1,5) do set num_a=!num_a!!num_a!
for /l %%b in (1,1,5) do set num_b=!num_b!!num_b!

set "sum="
set dupl_a=%num_a%
set dupl_b=%num_b%

for /l %%a in (1,1,10000) do (
    set /a va=1!num_a:~-8, 8!-BASE, vb=1!num_b:~-8, 8!-BASE
    set /a t = va + vb + carry
    if !t! geq !BASE! ( set /a carry=1 ) else ( set /a carry=0&set t=00000000!t!)
    set sum=!t:~-8!!sum!
    set num_a=00000000!num_a:~0,-8!
    set num_b=00000000!num_b:~0,-8!
    set dupl_a=!dupl_a:~8!
    set dupl_b=!dupl_b:~8!
    if "!dupl_a!!dupl_b!" == "" goto :next
)

:next
echo !sum!
exit /b
