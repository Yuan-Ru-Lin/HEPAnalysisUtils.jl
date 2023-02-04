using Optim, Distributions, ComponentArrays

data_pass = filter(x -> abs(x) < 5, [randn(1000); 10 .* rand(100) .- 5])
data_fail = filter(x -> abs(x) < 5, [randn(1000); 10 .* rand(3000) .- 5])
data_comb = [data_pass; data_fail]

model_sig(x) = Normal(x.μ, x.σ)
model_bkg(x) = Uniform(-5, 5)
nll_all(x, data) = (x.n_sig + x.n_bkg) - sum(log.(x.n_sig * pdf.(Ref(model_sig(x.sig)), data) + x.n_bkg * pdf.(Ref(model_bkg(x)), data)))

x0_pass = ComponentVector(sig=(μ=0.0, σ=1.0), n_sig=0.0, n_bkg=100.0)   # n_sig will be rewritten
x0_fail = ComponentVector(sig=(μ=0.0, σ=1.0), n_sig=0.0, n_bkg=3000.0)  # n_sig will be rewritten
x0_comb = ComponentVector(pass=x0_pass, fail=x0_fail, eff=0.5, n_sig=2000.0)
function nll_comb(x, data_pass, data_fail)
    x.pass.n_sig = x.eff * x.n_sig
    x.fail.n_sig = (1.0-x.eff) * x.n_sig
    nll_all(x.pass, data_pass) + nll_all(x.fail, data_fail)
end

res_comb = optimize(x -> nll_comb(x, data_pass, data_fail), x0_comb)

@show res_comb.minimizer.eff
