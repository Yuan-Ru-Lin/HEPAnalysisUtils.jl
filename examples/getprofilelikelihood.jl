using Optim, Distributions, ComponentArrays, HEPAnalysisUtils

data = randn(100)

"A loglikelihood with the extended term i.e. data size as a random variable of Poisson"
f(x, data) = - loglikelihood(Poisson(x.ν), length(data)) - loglikelihood(Normal(x.μ, x.σ), data)

x0 = ComponentVector(ν=100.0, μ=0.0, σ=1.0)
res0 = optimize(x -> f(x, data), x0)

using Plots
@info "Should see a 68%-C.I. (i.e. where -2\\Delta\\logL < 1) at aboud x = [90, 110]"
plot(y -> 2optimizeat(x -> f(x, data), res0; ν=y).minimum, 85:115)
xlabel!("\$\\nu\$")
ylabel!("\$-2\\Delta\\log L\$")
