#! /usr/bin/env julia

# wordA = 

function str2bits(str :: String) :: String
  length(str) != 1 && return
  return bits(str[1])
end

# XXX 現状のやつでは512-64バイト以上のものに対応できない
function padding(str :: String) :: String
  padding_1 = "1"  
  padding_length0 = 448 - str.len - padding_1.len
  padding_0 = join(fill(0, padding_length0))
  return "$str$padding_1$padding_0"
end

function append_length(str :: String, i :: Int) :: String
  return "$str$(bits(i))"
end

# XXX <<<を定義したかった
# 32bit？
function rotate_shift_left(x, n)
  x << n | x >> (bits(x).len - n)
end
