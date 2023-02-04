using Distributions, Optim, ComponentArrays

"""
See also MIGrad in Chapter 4: Minuit Commands, https://root.cern.ch/download/minuit.pdf
"""
function miunitstop(state::Optim.OptimizationState)
    mt = state.metadata
    edm = mt["g(x)"]' * mt["~inv(H)"] * mt["g(x)"] / 2
    edm < 1e-3 * 0.1 * 1.0
end

"""
    profile(f; pois...)

Curry a function whose only argument is a ComponentVector.
"""
profile(f; pois...) = f_profiled(; nuisances...) = f(ComponentVector(; pois..., nuisances...))

"""
    optimizeat(f, res0::Optim.OptimizationResults; pois...)

Provide
"""
function optimizeat(f, res0::Optim.OptimizationResults; pois...)
    nuisances = setdiff(keys(res0.minimizer), keys(pois))
    x0_nuisances = res0.minimizer[nuisances]
    optimize(x0_nuisances) do x
        profile(f; pois...)(; x...) - res0.minimum
    end
end

