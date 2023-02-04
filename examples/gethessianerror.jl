data = randn(1000)

using Distributions
nll(x, data) = -loglikelihood(Normal(x.μ, x.σ), data)

using ComponentArrays, Optim
x0 = ComponentVector(μ=0.0, σ=1.0)
res = optimize(x -> nll(x, data), x0)

using Zygote, LinearAlgebra, HEPAnalysisUtils
"""
A `ComponentVector` has to be constructed in the function passed to Zygote.hessian.
See also https://github.com/jonniedie/ComponentArrays.jl/issues/126#issuecomment-1141580528
"""
const axis = getaxes(x0)[1]
C = Zygote.hessian(x -> nll(ComponentVector(x, axis), data), res.minimizer)
V = inv(Symmetric(C))
err = sqrt.(diag(V))

using Measurements
measurements = res.minimizer .± err
@show measurements
