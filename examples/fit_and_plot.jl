data = randn(1000)
bins = -5:1e-1:5

using ComponentArrays, Optim, Distributions, HEPAnalysisUtils, Plots
res = optimize(ComponentArray(μ=0.0, σ=1.0)) do pars
    -loglikelihood(Normal(pars...), data)
end

plot(DataHist(), data, bins, Normal(res.minimizer...))

