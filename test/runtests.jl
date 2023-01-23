using HEPAnalysisUtils
using Optim
using Distributions

data = randn(100)
res = optimize([-Inf, 0.0], [Inf, Inf], [0.0, 1.0], Fminbox(BFGS()), Optim.Options(extended_trace=true, callback=miunitstop)) do pars
    -loglikelihood(Normal(pars...), data)
end

