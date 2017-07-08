#! /usr/bin/env julia

wordA = parse(Int, "$(bits(0x01))$(bits(0x23))$(bits(0x45))$(bits(0x67))", 2)
wordB = parse(Int, "$(bits(0x89))$(bits(0xab))$(bits(0xcd))$(bits(0xef))", 2)
wordC = parse(Int, "$(bits(0xfe))$(bits(0xdc))$(bits(0xba))$(bits(0x98))", 2)
wordD = parse(Int, "$(bits(0x76))$(bits(0x54))$(bits(0x32))$(bits(0x10))", 2)

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

function F_func(X :: Int, Y :: Int, Z :: Int) :: Int
  return X & Y | ~X & Z
end

function G_func(X :: Int, Y :: Int, Z :: Int) :: Int
  return X & Z | Y & ~Z
end

function H_func(X :: Int, Y :: Int, Z :: Int) :: Int
  return X $ Y $ Z
end

function I_func(X :: Int, Y :: Int, Z :: Int) :: Int
  return Y $ (X | ~Z)
end

"1 to 64"
function table(index :: Int) :: Int
  return round(Int, 4294967296*abs(sin(index)))
end

function md5(N)
  input = "a"
  input_bits = str2bits(input)
  b = input_bits.len
  p = padding(input_bits)
  M = append_length(p, b)
  A = wordA
  B = wordB
  C = wordC
  D = wordD
  # TODO fix
  N = 16
  # TODO fix to "for" expression
  i = 1
  X = [parse(Int, M[j * 32 - 31:j * 32], 2) for j in 1:16]
  A = B + rotate_shift_left(A + F_func(B,C,D) + X[1] + table(2), 7)
  return A
end
