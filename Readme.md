* 资料整理
  [Methods of computing square roots]
  (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots)

  Decimal (base 10)
  从左边开始，
  Starting on the left, bring down the most significant (leftmost) pair of digits not yet used (if all the digits have been used, write "00") and write them to the right of the remainder from the previous step (on the first step, there will be no remainder). In other words, multiply the remainder by 100 and add the two digits. This will be the current value c.

  Find the square root of 152.2756.

  ```
            1  2. 3  4 
          ____________
        \/ 01 52.27 56
           01                   1*1 <= 1 < 2*2                 x = 1
           01                     y = x*x = 1*1 = 1
           00 52                22*2 <= 52 < 23*3              x = 2
           00 44                  y = (20+x)*x = 22*2 = 44
              08 27             243*3 <= 827 < 244*4           x = 3
              07 29               y = (240+x)*x = 243*3 = 729
                 98 56          2464*4 <= 9856 < 2465*5        x = 4
                 98 56            y = (2460+x)*x = 2464*4 = 9856
                 00 00          Algorithm terminates: Answer is 12.34
  ```

  Find the square root of 2.
  ```
            1. 4  1  4  2
          _______________
        \/ 02.00 00 00 00
           02                  1*1 <= 2 < 2*2                 x = 1
           01                    y = x*x = 1*1 = 1
           01 00               24*4 <= 100 < 25*5             x = 4
           00 96                 y = (20+x)*x = 24*4 = 96
              04 00            281*1 <= 400 < 282*2           x = 1
              02 81              y = (280+x)*x = 281*1 = 281
              01 19 00         2824*4 <= 11900 < 2825*5       x = 4
              01 12 96           y = (2820+x)*x = 2824*4 = 11296
                 06 04 00      28282*2 <= 60400 < 28283*3     x = 2
                               The desired precision is achieved:
                               The square root of 2 is about 1.4142
  ```

* 关于二分搜索
  预判数值范围，通过 min max mid 三个变量迭代演化
  规则：如果 mid^2 gtr num 则max=mid（向下缩小范围），如果 lss num 则min=mid（向上缩小范围）
  例如一位数字的猜测（暂时排除0）
  min=1, max=9, mid=int((min+max)/2)=5
  假设猜测的数字是82
  25<82 min=5 max=9 mid=7
  49<82 min=7 max=9 mid=8
  64<82 min=8 max=9 mid=8
  这里就有个问题，mid将始终等于8，需要判断max-min=1时结束循环
  而且永远无法得到9作为测试数字

  修改方案，缩小范围的时候，当前mid已经不在范围内，应该排除，修改规则
  if mid^2 gtr num then max=mid-1，if mid^2 lss num then min=mid+1
  n=82  min=1 max=9 mid=5
  25<82 min=6 max=9 mid=7
  49<82 min=8 max=9 mid=8
  64<82 min=9 max=9 mid=9
  81<82 min == max , break loop

  在范围大的情况下，还可能减少循环次数

* Debug
  31625 1000140625 min:0 max:10 1 
  31622 999950884 min:0 max:5 1 
  31621 999887641 min:0 max:2 1 
  31620 999824400 min:0 max:1 1 
  cmp 出现误判，判定 999950884 > 1000000000

  cmp判断失误的原因，if "%len_a%" gtr "%len_b%"，
  由于加了双引号所以按字符串判断处理，判定 "9" gtr "10"
  将双引号去掉后问题解决





