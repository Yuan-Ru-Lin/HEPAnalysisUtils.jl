# # Fit and plot

# First we generate a 1000-sized sample from a standard Gaussian. In Julia, it's simply

data = randn(1000)

# Then blah

using ComponentArrays, Optim, Distributions, HEPAnalysisUtils, Plots
res = optimize(ComponentArray(μ=0.0, σ=1.0)) do pars
    -loglikelihood(Normal(pars...), data)
end

plot(DataHist(), data, bins, Normal(res.minimizer...))

