* Branch - SpeedUpB
  实测 `set /a buff[!sid!] += bar, buff[!next!] += foo` 占用 0.4 秒
  改用 goto 循环，使用 %sid% 作为数组索引，而不是!sid!，对比效率
