* BinSearch.bat
  * Section 1
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

  * Section 2
    修改规则
    if mid*mid gtr tg then max=mid
    if mid*mid leq tg then min=mid

    测试数字0
    tg=0 pow=25 min:1 max:5 mid:5 1
    tg=0 pow=9 min:1 max:3 mid:3 1
    tg=0 pow=4 min:1 max:2 mid:2 1
    tg=0 pow=1 min:1 max:1 mid:1 1
    tg=0 pow=1 min:1 max:1 mid:1

    测试数字82
    tg=82 pow=25 min:5 max:9 mid:5 -1
    tg=82 pow=49 min:7 max:9 mid:7 -1
    tg=82 pow=64 min:8 max:9 mid:8 -1
    tg=82 pow=64 min:8 max:9 mid:8 -1
    tg=82 pow=64 min:8 max:9 mid:8

    (8+9)/2 取整永远等于8，平方永远小于82。
    解决方法：扩大边界，初始min=0, max=10
    