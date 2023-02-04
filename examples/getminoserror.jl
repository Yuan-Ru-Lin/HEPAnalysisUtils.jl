using Optim, Distributions, ComponentArrays, HEPAnalysisUtils

data = randn(100)
nll(x, data) = - loglikelihood(Poisson(x.ν), length(data)) - loglikelihood(Normal(x.μ, x.σ), data)
x0 = ComponentVector(ν=100.0, μ=0.0, σ=1.0)
res = optimize(x -> nll(x, data), x0)

using Zygote, LinearAlgebra
const axis = getaxes(x0)[1]
C = Zygote.hessian(x -> nll(ComponentVector(x, axis), data), res.minimizer)
V = inv(Symmetric(C))
err = ComponentVector(sqrt.(diag(V)), axis)

using Roots
up = find_zero(y -> 2optimizeat(x -> nll(x, data), res; ν=y).minimum - 1.0, res.minimizer[:ν] + err[:ν])
lo = find_zero(y -> 2optimizeat(x -> nll(x, data), res; ν=y).minimum - 1.0, res.minimizer[:ν] - err[:ν])
@show up lo
