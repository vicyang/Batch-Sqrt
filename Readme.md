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

* sqrt_float_SpeecUpA
  优化笔记
  get_int_of_root 中
  set /a min = 1, max = 10, root_len = len / 2 + len %% 2
  for /l %%n in (2,1,%root_len%) do (set min=!min!0& set max=!max!9)
  如果长度是10, 实际得到 
  min=1000000000
  max=10999999999
  应改为set max=!max!0
  min=1000000000
  max=10000000000

  去掉大量求字符串长度的调用，期间犯了几个不容易发现的错误，
  :cmp 函数等若干函数中 从传参获取长度，
  set len_a=%3
  set len_b=%4
  因为修改后提供的参数可能是 %var%+1 %var%+2 需要计算公式，所以应该改为
  set /a len_a=%3
  set /a len_b=%4






