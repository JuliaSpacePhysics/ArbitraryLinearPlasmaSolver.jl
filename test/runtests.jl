using ArbitraryLinearPlasmaSolver
using Test
using Aqua

@testset "ArbitraryLinearPlasmaSolver.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(ArbitraryLinearPlasmaSolver)
    end
    # Write your tests here.
end

@testset "generate_distribution" begin
    using ArbitraryLinearPlasmaSolver.MPICH_jll
    cd(pkgdir(ArbitraryLinearPlasmaSolver))
    cd("examples/distribution") do
        run(`$(ArbitraryLinearPlasmaSolver.generate_distribution()) test_ICW_dist.in`)
    end

    @test "   0.0000000000000000       -6.0000000000000000        1.3885214326235464E-017" in readlines("examples/distribution/test_ICW.1.array")

    mpirun = MPICH_jll.mpiexec()  # or mpirun()
    cd("examples") do
        run(`$mpirun -np 4 $(ArbitraryLinearPlasmaSolver.ALPS().exec) tests/test_ICW.in`)
    end
end
