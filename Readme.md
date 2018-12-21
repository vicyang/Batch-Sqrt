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






