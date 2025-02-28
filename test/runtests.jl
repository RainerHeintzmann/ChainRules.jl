using Test, ChainRulesCore, ChainRulesTestUtils

@nospecialize

# don't interpret this, since this breaks some inference tests
@time include("test_helpers.jl")
println()

module Tests

using ..Main: Multiplier, NoRules
using Base.Broadcast: broadcastable
using ChainRules
using ChainRulesCore
using ChainRulesTestUtils
using ChainRulesTestUtils: rand_tangent, _fdm
using Compat: hasproperty, only, cispi, eachcol
using FiniteDifferences
using LinearAlgebra
using LinearAlgebra.BLAS
using LinearAlgebra: dot
using Random
using StaticArrays
using Statistics
using Test

@nospecialize

if isdefined(Base, :Experimental) && isdefined(Base.Experimental, Symbol("@compiler_options"))
    @eval Base.Experimental.@compiler_options compile=min optimize=0 infer=no
end

Random.seed!(1) # Set seed that all testsets should reset to.

function include_test(path::String)
    println("Testing $path:")  # print so TravisCI doesn't timeout due to no output
    @time include(path)  # show basic timing, (this will print a newline at end)
end

println("Testing ChainRules.jl")
@testset "ChainRules" begin
    @testset "rulesets" begin
        @testset "Core" begin
            include_test("rulesets/Core/core.jl")
        end

        @testset "Base" begin
            include_test("rulesets/Base/base.jl")
            include_test("rulesets/Base/fastmath_able.jl")
            include_test("rulesets/Base/evalpoly.jl")
            include_test("rulesets/Base/array.jl")
            include_test("rulesets/Base/arraymath.jl")
            include_test("rulesets/Base/indexing.jl")
            include_test("rulesets/Base/mapreduce.jl")
            include_test("rulesets/Base/sort.jl")
        end
        println()

        @testset "Statistics" begin
            include_test("rulesets/Statistics/statistics.jl")
        end
        println()

        @testset "LinearAlgebra" begin
            include_test("rulesets/LinearAlgebra/dense.jl")
            include_test("rulesets/LinearAlgebra/norm.jl")
            include_test("rulesets/LinearAlgebra/matfun.jl")
            include_test("rulesets/LinearAlgebra/structured.jl")
            include_test("rulesets/LinearAlgebra/symmetric.jl")
            include_test("rulesets/LinearAlgebra/factorization.jl")
            include_test("rulesets/LinearAlgebra/blas.jl")
            include_test("rulesets/LinearAlgebra/lapack.jl")
        end
        println()

        @testset "Random" begin
            include_test("rulesets/Random/random.jl")
        end
        println()
    end
end

end
