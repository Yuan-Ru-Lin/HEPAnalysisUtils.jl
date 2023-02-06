using Measurements, JLD2, HEPAnalysisUtils

corr1 = 1.0 ± 0.01

jldopen(datadir("db", "data.jld2"), "a+") do file
    file["correctionfactors/corr1"] = corr1
end
