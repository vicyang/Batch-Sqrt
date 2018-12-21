* BinSearch.bat
  范围收缩规则
  if mid*mid gtr tg then max=mid-1
  if mid*mid leq tg then min=mid+1

  测试数字 10 （求整数根）
  tg=10 pow=25 min:1 max:4 mid:5 1
  tg=10 pow=4 min:3 max:4 mid:2 -1
  tg=10 pow=9 min:4 max:4 mid:3 -1
  tg=10 pow=9 min:4 max:4 mid:4

  结论：对于不能完全匹配的数字，在缩小范围时不应该-1和+1（本意是为了加快缩小范围，减少可能的冗余计算）
  因为整数部分的结果可能就是mid，而非 mid-1 mid+1

  