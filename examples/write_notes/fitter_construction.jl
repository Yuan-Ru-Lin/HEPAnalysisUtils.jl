using Optim, Distributions, ComponentArrays, Plots, HEPAnalysisUtils

const miunitOptions::Optim.Options = Optim.Options(extended_trace=true, callback=miunitstop)

data_sig = randn(1000)
model_sig(x::ComponentArray) = Normal(x.μ, x.σ)
x_lo_sig = ComponentArray(μ=-5.0, σ=0.0)
x_up_sig = ComponentArray(μ=+5.0, σ=5.0)
x0_sig = ComponentArray(μ=0.0, σ=1.0)

@debug let p = plot(DataHist(), data_sig, -5:1e-1:5, model_sig(x0_sig), label=["Signal" "x0"])
    savefig(p, "sig.svg")
end

res_sig = optimize(x_lo_sig, x_up_sig, x0_sig, Fminbox(BFGS()), miunitOptions, autodiff=:forward) do pars
    -loglikelihood(model_sig(pars), data_sig)
end

data_bkg = rand(Exponential(2.0) - 5.0, 1000)
model_bkg(x::ComponentArray) = Exponential(x.τ) - 5.0
x_lo_bkg = ComponentArray(τ=0.0)
x_up_bkg = ComponentArray(τ=5.0)
x0_bkg = ComponentArray(τ=2.0)

@debug let p = plot(DataHist(), data_bkg, -5:1e-1:5, model_bkg(x0_bkg), label=["Background" "x0"])
    savefig(p, "bkg.svg")
end

res_bkg = optimize(x_lo_bkg, x_up_bkg, x0_bkg, Fminbox(BFGS()), miunitOptions, autodiff=:forward) do pars
    -loglikelihood(model_bkg(pars), data_bkg)
end

data_all = [data_sig; data_bkg]
model_all(x::ComponentArray) = MixtureModel([model_sig(x.sig), model_bkg(x.bkg)], [x.f, 1-x.f])
x0_all = ComponentArray(sig=res_sig.minimizer, bkg=res_bkg.minimizer, f=0.1)

@debug let p = plot(DataHist(), data_all, -5:1e-1:5, model_all(x0_all), label=["All" "x0"])
    savefig(p, "all.svg")
end

res_all = optimize(
                   ComponentArray(sig=x_lo_sig, bkg=x_lo_bkg, f=0.0),
                   ComponentArray(sig=x_up_sig, bkg=x_up_bkg, f=1.0),
                   x0_all,
                   Fminbox(BFGS()), miunitOptions, autodiff=:forward) do pars
    -loglikelihood(model_all(pars), data_all)
end
