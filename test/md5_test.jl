#! /usr/bin/env julia
include("../main.jl")

using Base.Test
@testset "str2bits" begin
  @test str2bits("a") == "00000000000000000000000001100001"
end
@testset "padding" begin
  @test padding("").len == 448
  @test padding(join(fill("0", 10))).len == 448
  @test padding(join(fill("0", 447))).len == 448
end
@testset "append_length" begin
  @test append_length("", 2) == "0000000000000000000000000000000000000000000000000000000000000010"
end
@testset "rotate" begin
  @test bits(rotate_shift_left(Int8(1), 1)) == bits(Int8(1) << 1)
  @test bits(rotate_shift_left(Int8(-1), 1)) == bits(Int8(-1))
end

