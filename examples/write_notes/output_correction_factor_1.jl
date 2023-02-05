using Measurements, JLD2

corr1 = 1.0 ± 0.01

jldopen("data.jld2", "a+") do file
    file["correctionfactors/corr1"] = corr1
end
