using Documenter, Literate, HEPAnalysisUtils

EXAMPLE = joinpath(@__DIR__, "..", "examples", "fit_and_plot.jl")
OUTPUT = joinpath(@__DIR__, "src/tutorials/")
Literate.markdown(EXAMPLE, OUTPUT)

makedocs(
    sitename = "HEPAnalysisUtils",
    pages = Any[
        "Home" => "index.md",
	"Tutorials" => Any[
	    "tutorials/fit_and_plot.md",
	],
	"APIs" => "api.md",
    ]
)
deploydocs(
    repo = "github.com/Yuan-Ru-Lin/HEPAnalysisUtils.jl.git",
    push_preview = true,
)
