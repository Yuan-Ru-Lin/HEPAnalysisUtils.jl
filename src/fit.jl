using Optim

"""
See also [MIGrad in Chapter 4: Minuit Commands, MINUIT Reference Manual](https://root.cern.ch/download/minuit.pdf)
"""
function miunitstop(state::Optim.OptimizationState)::Bool
    mt = state.metadata
    edm = mt["g(x)"]' * mt["~inv(H)"] * mt["g(x)"] / 2
    edm < 1e-3 * 0.1 * 1.0
end

import Optim: default_options
using Optim: BFGS
default_options(::BFGS) = (; extended_trace=true, callback=miunitstop)

function MiunitOptions(; additionals...)::Optim.Options
    Optim.Options(extended_trace=true, callback=miunitstop; additionals...)
end

import Optim: optimize
"""
So that it uses the Miunit stopping criteria automatically

A bad thing is that it collides with the the default function signature since
there is no `default_options` mechanism for `optimize` function that takes
`Fminbox` (as per Optim 1.7.4)

See also [this issue](https://github.com/JuliaNLSolvers/Optim.jl/issues/1028).
"""
function optimize(f,
                  l::AbstractArray,
                  u::AbstractArray,
                  initial_x::AbstractArray,
                  F::T) where {T <: Fminbox}
    optimize(f, l, u, initial_x, F, MiunitOptions())
end

"""
    profile(f; pois...)

Curry a function of a `NamedTuple`-like variable.

# Examples
```jldoctest
julia> f(x) = x.a + x.b + x.c
julia> profile(f; a=1)(b=2, c=3)
6
```

"""
profile(f; pois...) = f_profiled(; nuisances...) = f((; pois..., nuisances...))

"""
    optimizeat(f, res0::Optim.OptimizationResults; pois...)

Optimize a function of a `NamedTuple`-like varialbe, `f`, where parameters of
interest (pois) are fixed (specified as keyword arguments) and nuisances
parameter are floated.
"""
function optimizeat(f, res0::Optim.OptimizationResults; pois...)::Optim.OptimizationResults
    nuisances = setdiff(keys(res0.minimizer), keys(pois))
    x0_nuisances = res0.minimizer[nuisances]
    optimize(x0_nuisances) do x
        profile(f; pois...)(; x...) - res0.minimum
    end
end
