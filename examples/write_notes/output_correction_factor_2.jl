using Measurements, JLD2

corr2 = 42.0 ± 10.0

jldopen("data.jld2", "a+") do file
    file["correctionfactors/corr2"] = corr2
end
