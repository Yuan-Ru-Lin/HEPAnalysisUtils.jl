using Measurements, DataFrames, LaTeXStrings

include("tools.jl")

a = 1.0 ± 0.01
df = DataFrame(source=[L"Number of $B\bar{B}$"], uncertainty=[latexify(a)])
write("tab.tex", latexify(df, latex=false, env=:table, head=["YO1", "YO2"], adjustment=[:c, :c], booktabs=true))
write("tab.md", latexify(df, latex=false, env=:mdtable, head=["YO1", "YO2"], adjustment=[:c, :c]) |> string)
