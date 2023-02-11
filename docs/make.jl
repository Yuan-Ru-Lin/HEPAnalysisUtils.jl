using Documenter, HEPAnalysisUtils

makedocs(
    sitename = "HEPAnalysisUtils",
    pages = Any[
        "Home" => "index.md",
	"Tutorials" => "tutorials.md",
    ]
)

deploydocs(
    repo = "github.com/Yuan-Ru-Lin/HEPAnalysisUtils.jl.git"
)
