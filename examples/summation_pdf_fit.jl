using Optim, Distributions, ComponentArrays

data = filter(x -> abs(x) < 5, [randn(200); 10 .* rand(1000) .- 5])

model_sig(x) = Normal(x.μ, x.σ)
model_bkg(x) = Uniform(-5, 5)
function nll(x, data)
    (x.n_sig + x.n_bkg) -
    sum(log.(x.n_sig * pdf.(Ref(model_sig(x.sig)), data) +
             x.n_bkg * pdf.(Ref(model_bkg(x)), data)))
end

x0 = ComponentVector(sig=(μ=0.0, σ=1.0), n_sig=200.0, n_bkg=1000.0)
res = optimize(x -> nll(x, data), x0)
