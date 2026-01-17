using ArbitraryLinearPlasmaSolver
using Test
using Aqua

@testset "ArbitraryLinearPlasmaSolver.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(ArbitraryLinearPlasmaSolver)
    end
    # Write your tests here.
end
