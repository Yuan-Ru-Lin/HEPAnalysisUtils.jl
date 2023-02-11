```@meta
EditURL = "<unknown>/../examples/fit_and_plot.jl"
```

````@example fit_and_plot
data = randn(1000)
bins = -5:1e-1:5
````

Not sure how this will look like

````@example fit_and_plot
using ComponentArrays, Optim, Distributions, HEPAnalysisUtils, Plots
res = optimize(ComponentArray(μ=0.0, σ=1.0)) do pars
    -loglikelihood(Normal(pars...), data)
end

plot(DataHist(), data, bins, Normal(res.minimizer...))
````

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

