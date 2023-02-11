# # Fit and plot

# First we generate a 1000-sized sample from a standard Gaussian. In Julia, it's simply

data = randn(1000)

# Then blah

using ComponentArrays, Optim, Distributions, HEPAnalysisUtils, Plots
res = optimize(ComponentArray(μ=0.0, σ=1.0)) do x
    -loglikelihood(Normal(x.μ, x.σ), data)
end

plot(DataHist(), data, -5:1e-1:5, Normal(res.minimizer.μ, res.minimizer.σ))

