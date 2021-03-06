#! /usr/bin/env julia

wordA = 0x67452301
wordB = 0xefcdab89
wordC = 0x98badcfe
wordD = 0x10325476

function str2bits(str :: String) :: String
  return join([bin(s, 8) for s in str])
end

# XXX 現状のやつでは512-64バイト以上のものに対応できない
function padding(str :: String) :: String
  padding_1 = "1"
  padding_length0 = 448 - str.len - padding_1.len
  padding_0 = join(fill(0, padding_length0))
  return "$str$padding_1$padding_0"
end

function append_length(str :: String, i :: Int64) :: String
  bitss = join(reverse([bits(i)[j*8-7:j*8] for j in 1:8]))
  return "$str$(bitss)"
end

# XXX <<<を定義したかった
# 32bit？
function rotate_shift_left(x :: UInt32, n :: Int64) :: UInt32
  return x << n | x >> (bits(x).len - n)
end

function F_func(X :: UInt32, Y :: UInt32, Z :: UInt32) :: UInt32
  return X & Y | ~X & Z
end

function G_func(X :: UInt32, Y :: UInt32, Z :: UInt32) :: UInt32
  return X & Z | Y & ~Z
end


function H_func(X :: UInt32, Y :: UInt32, Z :: UInt32) :: UInt32
  return X ⊻ Y ⊻ Z
end


function I_func(X :: UInt32, Y :: UInt32, Z :: UInt32) :: UInt32
  return Y ⊻ (X | ~Z)
end

"1 to 64"
function table(index :: Int) :: UInt32
  return floor(UInt32, 2^32*abs(sin(BigInt(index))))
end

function md5(input :: String)
  if(typeof(input) == String)
    input_bits = str2bits(input)
  else
    input_bits = "01100001"
  end
  b = input_bits.len
  print(b)
  p = padding(input_bits)
  M = append_length(p, b)
  # M = join(fill("0", 16))*"1000000001100001"*join(fill("0", 32*13))*"00000000000000000000000000001000"*join(fill("0", 32))
  # M = "00000000000000000000000000001000"*join(fill("0", 32*13))*join(fill("0", 32))*join(fill("0", 16))*"1000000001100001"
  # M="0110000110000000"*join(fill("0",16))*join(fill("0",32*13))*"0000100000000000"*join(fill("0", 16))*join(fill("0", 32))
  println(M)
  println(M.len)
  A = wordA
  B = wordB
  C = wordC
  D = wordD
  # TODO fix
  N = 16
  # TODO fix to "for" expression
  # i = 1
  # fuck
  # X = [parse(UInt32, M[j * 32 - 31:j * 32], 2) for j in 1:16]
  X = [parse(UInt32, M[j * 32 - 7:j * 32]*M[j * 32 - 15:j * 32 - 8]*M[j * 32 - 23:j * 32 - 16]*M[j * 32 - 31:j * 32 - 24], 2) for j in 1:16]
  # type of lambda?
  function update(A :: UInt32, B :: UInt32, C :: UInt32, D :: UInt32, k :: Int, s :: Int, i :: Int, f) :: UInt32
    return UInt32(B + rotate_shift_left(A + f(B,C,D) + X[k] + table(i), s))
  end
  val = 0
  # TODO worst solution
  # 1
  f = F_func
  s_1 = 7
  s_2 = 12
  s_3 = 17
  s_4 = 22
  println(X)
  A = update(A, B, C, D, 1, s_1, val+=1, f)
  D = update(D, A, B, C, 2, s_2, val+=1, f)
  C = update(C, D, A, B, 3, s_3, val+=1, f)
  B = update(B, C, D, A, 4, s_4, val+=1, f)
  A = update(A, B, C, D, 5, s_1, val+=1, f)
  D = update(D, A, B, C, 6, s_2, val+=1, f)
  C = update(C, D, A, B, 7, s_3, val+=1, f)
  B = update(B, C, D, A, 8, s_4, val+=1, f)
  A = update(A, B, C, D, 9, s_1, val+=1, f)
  D = update(D, A, B, C, 10, s_2, val+=1, f)
  C = update(C, D, A, B, 11, s_3, val+=1, f)
  B = update(B, C, D, A, 12, s_4, val+=1, f)
  A = update(A, B, C, D, 13, s_1, val+=1, f)
  D = update(D, A, B, C, 14, s_2, val+=1, f)
  C = update(C, D, A, B, 15, s_3, val+=1, f)
  B = update(B, C, D, A, 16, s_4, val+=1, f)
  # 2
  s_1 = 5
  s_2 = 9
  s_3 = 14
  s_4 = 20
  f = G_func
  A = update(A, B, C, D, 2, s_1, val+=1, f)
  D = update(D, A, B, C, 7, s_2, val+=1, f)
  C = update(C, D, A, B, 12, s_3, val+=1, f)
  B = update(B, C, D, A, 1, s_4, val+=1, f)
  A = update(A, B, C, D, 6, s_1, val+=1, f)
  D = update(D, A, B, C, 11, s_2, val+=1, f)
  C = update(C, D, A, B, 16, s_3, val+=1, f)
  B = update(B, C, D, A, 5, s_4, val+=1, f)
  A = update(A, B, C, D, 10, s_1, val+=1, f)
  D = update(D, A, B, C, 15, s_2, val+=1, f)
  C = update(C, D, A, B, 4, s_3, val+=1, f)
  B = update(B, C, D, A, 9, s_4, val+=1, f)
  A = update(A, B, C, D, 14, s_1, val+=1, f)
  D = update(D, A, B, C, 3, s_2, val+=1, f)
  C = update(C, D, A, B, 8, s_3, val+=1, f)
  B = update(B, C, D, A, 13, s_4, val+=1, f)
  # 3
  s_1 = 4
  s_2 = 11
  s_3 = 16
  s_4 = 23
  f = H_func
  A = update(A, B, C, D, 6, s_1, val+=1, f)
  D = update(D, A, B, C, 9, s_2, val+=1, f)
  C = update(C, D, A, B, 12, s_3, val+=1, f)
  B = update(B, C, D, A, 15, s_4, val+=1, f)
  A = update(A, B, C, D, 2, s_1, val+=1, f)
  D = update(D, A, B, C, 5, s_2, val+=1, f)
  C = update(C, D, A, B, 8, s_3, val+=1, f)
  B = update(B, C, D, A, 11, s_4, val+=1, f)
  A = update(A, B, C, D, 14, s_1, val+=1, f)
  D = update(D, A, B, C, 1, s_2, val+=1, f)
  C = update(C, D, A, B, 4, s_3, val+=1, f)
  B = update(B, C, D, A, 7, s_4, val+=1, f)
  A = update(A, B, C, D, 10, s_1, val+=1, f)
  D = update(D, A, B, C, 13, s_2, val+=1, f)
  C = update(C, D, A, B, 16, s_3, val+=1, f)
  B = update(B, C, D, A, 3, s_4, val+=1, f)
  # 4
  s_1 = 6
  s_2 = 10
  s_3 = 15
  s_4 = 21
  f = I_func
  A = update(A, B, C, D, 1, s_1, val+=1, f)
  D = update(D, A, B, C, 8, s_2, val+=1, f)
  C = update(C, D, A, B, 15, s_3, val+=1, f)
  B = update(B, C, D, A, 6, s_4, val+=1, f)
  A = update(A, B, C, D, 13, s_1, val+=1, f)
  D = update(D, A, B, C, 4, s_2, val+=1, f)
  C = update(C, D, A, B, 11, s_3, val+=1, f)
  B = update(B, C, D, A, 2, s_4, val+=1, f)
  A = update(A, B, C, D, 9, s_1, val+=1, f)
  D = update(D, A, B, C, 16, s_2, val+=1, f)
  C = update(C, D, A, B, 7, s_3, val+=1, f)
  B = update(B, C, D, A, 14, s_4, val+=1, f)
  A = update(A, B, C, D, 5, s_1, val+=1, f)
  D = update(D, A, B, C, 12, s_2, val+=1, f)
  C = update(C, D, A, B, 3, s_3, val+=1, f)
  B = update(B, C, D, A, 10, s_4, val+=1, f)

  # 加算で増えるから& 0xffffffffするか% 0xffffffffするか
  A = wordA + A
  B = wordB + B
  C = wordC + C
  D = wordD + D
  println("A:$(bits(A))")
  println("B:$(bits(B))")
  println("C:$(bits(C))")
  println("D:$(bits(D))")


  A = join(reverse([hex(parse(UInt,bits(A)[i*8-7:i*8],2),2) for i in 1:4]))
  B = join(reverse([hex(parse(UInt,bits(B)[i*8-7:i*8],2),2) for i in 1:4]))
  C = join(reverse([hex(parse(UInt,bits(C)[i*8-7:i*8],2),2) for i in 1:4]))
  D = join(reverse([hex(parse(UInt,bits(D)[i*8-7:i*8],2),2) for i in 1:4]))

  print(A)
  print(B)
  print(C)
  println(D)
  # print(hex(D))
  # print(hex(C))
  # print(hex(B))
  # println(hex(A))
  # println(hex(parse(UInt128, "$(bits(D))$(bits(C))$(bits(B))$(bits(A))", 2)))
  # println(hex(parse(UInt128, "$(bits(A))$(bits(B))$(bits(C))$(bits(D))", 2)))
end
