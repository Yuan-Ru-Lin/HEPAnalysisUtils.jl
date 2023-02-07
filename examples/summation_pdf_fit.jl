using Optim, Distributions, ComponentArrays, HEPAnalysisUtils

data = filter(x -> abs(x) < 5, [randn(200); rand(Exponential(2.0) - 5.0, 1000)])

model_sig(x) = Normal(x.μ, x.σ)
model_bkg(x) = Exponential(x.τ) - 5.0
function model_all(x)
    ν = x.n_sig + x.n_bkg
    f = x.n_sig / ν
    Extended(MixtureModel([model_sig(x.sig), model_bkg(x.bkg)], [f, 1-f]), ν)
end

x0 = ComponentVector(sig=(μ=0.0, σ=1.0), bkg=(τ=2.0,), n_sig=200.0, n_bkg=1000.0)
res = optimize(x -> -loglikelihood(model_all(x), data), x0)

plot(DataHist(), data, -5:1e-1:5)
plot!(Extended(model_sig(res.minimizer.sig), res.minimizer.n_sig), bins=-5:1e-1:5, label="Signal")
plot!(Extended(model_bkg(res.minimizer.bkg), res.minimizer.n_bkg), bins=-5:1e-1:5, label="Background")
plot!(model_all(res.minimizer), bins=-5:1e-1:5, label="All")
