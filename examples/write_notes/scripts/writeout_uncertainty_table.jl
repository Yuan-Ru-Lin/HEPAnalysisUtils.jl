using DataFrames, LaTeXStrings, JLD2, HEPAnalysisUtils, Measurements, Latexify

struct RelativeError err end
relerr(m::Measurement) = RelativeError(m.err / m.val)
@latexrecipe function f(err::RelativeError)
    fmt := FancyNumberFormatter(2)
    return err.err * 100
end

file = jldopen(datadir("db", "data.jld2"), "r")

df = DataFrame(source=AbstractString[], uncertainty=Measurement[])
push!(df, (L"Term $1$", file["correctionfactors/corr1"]))
push!(df, (L"Term $2$", file["correctionfactors/corr2"]))
df.relative_error_in_percentage = relerr.(df.uncertainty)

write(datadir("tables", "tab.tex"), latexify(latexify.(df), latex=false, env=:table, head=["Source" "Factor" "Uncertainty (\\%)"], adjustment=[:c, :c, :r], booktabs=true))
write(datadir("tables", "tab.md"), latexify(latexify.(df), latex=false, env=:mdtable, head=["Source" "Factor" "Uncertainty (%)"], adjustment=[:c, :c, :r]) |> string)
