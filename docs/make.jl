using ArbitraryLinearPlasmaSolver
using Documenter

DocMeta.setdocmeta!(ArbitraryLinearPlasmaSolver, :DocTestSetup, :(using ArbitraryLinearPlasmaSolver); recursive=true)

makedocs(;
    modules=[ArbitraryLinearPlasmaSolver],
    authors="Beforerr <zzj956959688@gmail.com> and contributors",
    sitename="ArbitraryLinearPlasmaSolver.jl",
    format=Documenter.HTML(;
        canonical="https://JuliaSpacePhysics.github.io/ArbitraryLinearPlasmaSolver.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaSpacePhysics/ArbitraryLinearPlasmaSolver.jl",
    devbranch="main",
)
