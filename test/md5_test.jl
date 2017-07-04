#! /usr/bin/env julia
include("../te.jl")

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
  @test append_length("", 2) == "00000000000000000000000000000010"
end