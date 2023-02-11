using Documenter, HEPAnalysisUtils

makedocs(
    sitename = "HEPAnalysisUtils",
    pages = Any[
        "Home" => "index.md",
	"Tutorials" => Any[
	    "tutorials/simple_fit.md",
	]
    ]
)
