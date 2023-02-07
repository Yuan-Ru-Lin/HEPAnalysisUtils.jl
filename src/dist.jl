using Distributions

struct Extended{D<:Distribution, N<:Real}
    d::D
    ν::N
    Extended{D,N}(d::D, ν::N) where {D<:Distribution, N<:Real} = new{D,N}(d, ν)
end

function Extended(d::D, ν::N; check_args::Bool=true) where {D<:Distribution, N<:Real}
    check_args && ν < 0 && error("ν = $ν < 0")
    Extended{D,N}(d, ν)
end

import Distributions: loglikelihood
loglikelihood(ed::Extended{D}, xs::AbstractArray) where {D<:Distribution} = loglikelihood(Poisson(ed.ν), length(xs)) + loglikelihood(ed.d, xs)

using Plots
using StatsPlots
@recipe function f(::Type{Extended{D}}, ed::Extended{D}) where {D<:Distribution}
    components --> false
    _step = step(plotattributes[:bins])
    func := (dist, x) -> pdf(dist, x) * ed.ν * _step
    ed.d
end
