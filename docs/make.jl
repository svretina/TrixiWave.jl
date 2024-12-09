using TrixiWave
using Documenter

DocMeta.setdocmeta!(TrixiWave, :DocTestSetup, :(using TrixiWave); recursive=true)

makedocs(;
    modules=[TrixiWave],
    authors="Stamatis Vretinaris",
    sitename="TrixiWave.jl",
    format=Documenter.HTML(;
        canonical="https://svretina.github.io/TrixiWave.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/svretina/TrixiWave.jl",
    devbranch="master",
)
